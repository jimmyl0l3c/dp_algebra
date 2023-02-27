from django.db import models


class Language(models.Model):
    code = models.CharField(max_length=5, unique=True)
    name = models.CharField(max_length=150)

    def __str__(self):
        return f'{self.id}_{self.code}'


class Chapter(models.Model):
    order = models.BigIntegerField(db_index=True)

    def __str__(self):
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

    def __str__(self):
        return f'{self.page}, Block: {self.id} ({self.order})'

    class Meta:
        ordering = ['order']


class BlockTranslation(models.Model):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    block = models.ForeignKey(Block, on_delete=models.CASCADE)
    title = models.CharField(max_length=150, blank=True)
    content = models.TextField()

    def __str__(self):
        return f'{self.block}/{self.language}'

    class Meta:
        db_table = 'articles_block_translations'


class Literature(models.Model):
    ref_name = models.CharField(max_length=50, unique=True)
    author = models.CharField(max_length=150)
    year = models.CharField(max_length=10)

    def __str__(self):
        return f'{self.ref_name}: {self.author}, {self.year}'

# TODO: add term dictionary
