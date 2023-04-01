import re

from django.db import models
from django.db.models import F


class Language(models.Model):
    code = models.CharField(max_length=5, unique=True)
    name = models.CharField(max_length=150)

    def __str__(self):
        return f'{self.id}_{self.code}'


class Chapter(models.Model):
    order = models.BigIntegerField(db_index=True)

    def __str__(self):
        translation = Chapter.objects.filter(pk=self.pk).values(
            name=F('chaptertranslation__title')
        ).order_by('chaptertranslation__language')[:1]
        if translation.exists():
            return f'{self.id}: {translation.get()["name"]} ({self.order})'
        return f'Chapter: {self.id} ({self.order})'

    class Meta:
        ordering = ['order']


class ChapterTranslation(models.Model):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE)
    title = models.CharField(max_length=150)
    description = models.CharField(max_length=250, blank=True)

    def __str__(self):
        return f'{self.chapter}/{self.language}: {self.title}'

    class Meta:
        db_table = 'articles_chapter_translations'


class Article(models.Model):
    order = models.BigIntegerField(db_index=True)
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE)
    published_at = models.DateField()

    def __str__(self):
        article_translation = Article.objects.filter(pk=self.pk).values(
            name=F('articletranslation__title')
        ).order_by('articletranslation__language')[:1]
        if article_translation.exists():
            return f'{self.id}: {article_translation.get()["name"]} ({self.order})'
        return f'{self.chapter}, Article: {self.id} ({self.order})'

    class Meta:
        ordering = ['order']


class ArticleTranslation(models.Model):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    article = models.ForeignKey(Article, on_delete=models.CASCADE)
    title = models.CharField(max_length=150)
    description = models.CharField(max_length=250, blank=True)

    def __str__(self):
        return f'{self.article}/{self.language}: {self.title}'

    class Meta:
        db_table = 'articles_article_translations'


class Page(models.Model):
    order = models.BigIntegerField(db_index=True)
    article = models.ForeignKey(Article, on_delete=models.CASCADE)

    def __str__(self):
        return f'{self.article}, Page: {self.id} ({self.order})'

    class Meta:
        ordering = ['order']


class BlockType(models.Model):
    show_title = models.BooleanField(db_index=True)
    enumerated = models.BooleanField(db_index=True)

    def __str__(self):
        type_translation = BlockType.objects.filter(pk=self.pk).values(
            name=F('blocktypetranslation__title')
        ).order_by('blocktypetranslation__language')[:1]
        if type_translation.exists():
            return f'{self.id}: {type_translation.get()["name"]}'
        return f'{self.id} ({self.enumerated})'


class BlockTypeTranslation(models.Model):
    block_type = models.ForeignKey(BlockType, on_delete=models.CASCADE)
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    title = models.CharField(max_length=100)

    def __str__(self):
        return f'{self.block_type}/{self.language}: {self.title}'


class Block(models.Model):
    order = models.BigIntegerField(db_index=True)
    page = models.ForeignKey(Page, on_delete=models.CASCADE)
    type = models.ForeignKey(BlockType, on_delete=models.CASCADE)
    number = models.PositiveIntegerField(null=True, blank=True)

    def save(self, *args, **kwargs):
        if self.type.enumerated and not Block.objects.filter(pk=self.pk).exists():
            self.number = Block.objects.filter(type__enumerated=True).count() + 1
        # TODO: recalculate numbers if the object was not numerated before and should be now
        super().save(*args, **kwargs)

    def __str__(self):
        return f'{self.page}, Block: {self.id} ({self.order})'

    class Meta:
        ordering = ['order']


class BlockTranslation(models.Model):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    block = models.ForeignKey(Block, on_delete=models.CASCADE)
    title = models.CharField(max_length=150, blank=True)
    content = models.TextField()

    def save(self, *args, **kwargs):
        # Replace end of paragraph with \break tag
        self.content = re.sub(r"(\r?\n){2,}",  r" \\break ", self.content)
        # Filter out extra white spaces
        self.content = re.sub(r"[\n\r\t]",  " ", self.content)
        self.content = re.sub(r" {2,}", " ", self.content)
        self.content = re.sub(r"(\\cite{\S+)\s+(\S+})", r"\g<1>\g<2>", self.content)
        # Replace \begin{align} with matrix in display math block
        self.content = re.sub(r"(\\begin{)align\*(})", r"$$\g<1>matrix\g<2>", self.content)
        self.content = re.sub(r"(\\end{)align\*(})", r"\g<1>matrix\g<2>$$", self.content)
        # Replace tilda
        self.content = re.sub(r"~", " ", self.content)
        # Replace \uv{}
        self.content = re.sub(r"\\uv{(.*?)}", "\u201e\\g<1>\u201c", self.content)
        super().save(*args, **kwargs)

    def __str__(self):
        return f'{self.block}/{self.language}'

    class Meta:
        db_table = 'articles_block_translations'


class Literature(models.Model):
    ref_name = models.CharField(max_length=50, unique=True)
    author = models.CharField(max_length=150)
    year = models.CharField(max_length=10)
    title = models.CharField(max_length=100)
    location = models.CharField(max_length=100)
    publisher = models.CharField(max_length=100)
    isbn = models.CharField(max_length=18, blank=True, null=True)
    edition = models.IntegerField(blank=True, null=True)
    pages = models.IntegerField(blank=True, null=True)

    def __str__(self):
        return f'{self.ref_name}: {self.author}, {self.year}, {self.title}'


class RefLabel(models.Model):
    ref_name = models.CharField(max_length=50, unique=True)
    block = models.ForeignKey(Block, on_delete=models.CASCADE)

    def __str__(self):
        return f'{self.ref_name}: {self.block}'


class LearnImage(models.Model):
    ref_name = models.CharField(max_length=50, unique=True)
    image = models.ImageField(upload_to=f'learn_images')
    number = models.PositiveIntegerField(null=True, blank=True)

    def __str__(self):
        return self.ref_name
