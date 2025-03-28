import re

from django.db import models
from django.db.models import F, Q


class Language(models.Model):
    code = models.CharField(max_length=5, unique=True)
    name = models.CharField(max_length=150)

    class Meta:
        ordering = ["code"]

    def __str__(self):
        return f"{self.id}: {self.code}"


class Chapter(models.Model):
    order = models.BigIntegerField(db_index=True)

    class Meta:
        ordering = ["order"]

    def __str__(self):
        translation = (
            Chapter.objects.filter(pk=self.pk)
            .values(name=F("chaptertranslation__title"))
            .order_by("chaptertranslation__language")[:1]
        )
        if translation.exists():
            return f'{self.id}: {translation.get()["name"]} ({self.order})'
        return f"Chapter: {self.id} ({self.order})"


class ChapterTranslation(models.Model):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE)
    title = models.CharField(max_length=150)
    description = models.CharField(max_length=250, blank=True)

    class Meta:
        db_table = "articles_chapter_translations"
        ordering = ["language"]

    def __str__(self):
        return f"{self.chapter}/{self.language}: {self.title}"


class Article(models.Model):
    order = models.BigIntegerField(db_index=True)
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE)
    published_at = models.DateField()

    class Meta:
        ordering = ["chapter__order", "order"]

    def __str__(self):
        article_translation = (
            Article.objects.filter(pk=self.pk)
            .values(name=F("articletranslation__title"))
            .order_by("articletranslation__language")[:1]
        )
        if article_translation.exists():
            return f'{self.id}: {article_translation.get()["name"]} ({self.order})'
        return f"{self.chapter}, Article: {self.id} ({self.order})"


class ArticleTranslation(models.Model):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    article = models.ForeignKey(Article, on_delete=models.CASCADE)
    title = models.CharField(max_length=150)
    description = models.CharField(max_length=250, blank=True)

    class Meta:
        db_table = "articles_article_translations"
        ordering = ["language"]

    def __str__(self):
        return f"{self.article}/{self.language}: {self.title}"


class Page(models.Model):
    order = models.BigIntegerField(db_index=True)
    article = models.ForeignKey(Article, on_delete=models.CASCADE)

    class Meta:
        ordering = ["article__chapter__order", "article__order", "order"]

    def __str__(self):
        return f"{self.article}, Page: {self.id} ({self.order})"


class BlockType(models.Model):
    show_title = models.BooleanField(db_index=True)
    enumerated = models.BooleanField(db_index=True)
    figure = models.BooleanField(db_index=True)
    code = models.CharField(max_length=50, unique=True)

    class Meta:
        ordering = ["id"]

    def __str__(self):
        return f"{self.id}: {self.code}"


class BlockTypeTranslation(models.Model):
    block_type = models.ForeignKey(BlockType, on_delete=models.CASCADE)
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    title = models.CharField(max_length=100)

    class Meta:
        ordering = ["language"]

    def __str__(self):
        return f"{self.block_type}/{self.language}: {self.title}"


class Block(models.Model):
    order = models.BigIntegerField(db_index=True)
    page = models.ForeignKey(Page, on_delete=models.CASCADE)
    type = models.ForeignKey(BlockType, on_delete=models.CASCADE)
    number = models.PositiveIntegerField(null=True, blank=True)
    ref_label = models.CharField(max_length=50, unique=True, null=True, blank=True)

    class Meta:
        ordering = [
            "page__article__chapter__order",
            "page__article__order",
            "page__order",
            "order",
        ]

    def __str__(self):
        return f"{self.page}, Block: {self.id} ({self.order})"

    def save(self, *args, **kwargs) -> None:  # noqa: ANN002, ANN003
        if self.type.enumerated or self.type.figure:
            self.number = self.calculate_number()
            self.__update_following_enumerated()
        super().save(*args, **kwargs)

    def calculate_number(self) -> int | None:
        if not self.type.enumerated and not self.type.figure:
            return None
        type_filter = {"type__enumerated": True}
        if self.type.figure:
            type_filter = {"type__figure": True}
        preceding_count = Block.objects.filter(
            Q(page__article__chapter__order__lt=self.page.article.chapter.order)
            | Q(
                page__article__chapter=self.page.article.chapter,
                page__article__order__lt=self.page.article.order,
            )
            | Q(page__article=self.page.article, page__order__lt=self.page.order)
            | Q(page=self.page, order__lt=self.order),
            **type_filter,
        ).count()
        return preceding_count + 1

    def __update_following_enumerated(self):
        if not self.type.enumerated and not self.type.figure:
            return
        type_filter = {"type__enumerated": True}
        if self.type.figure:
            type_filter = {"type__figure": True}

        following = Block.objects.filter(
            Q(page__article__chapter__order__gt=self.page.article.chapter.order)
            | Q(
                page__article__chapter=self.page.article.chapter,
                page__article__order__gt=self.page.article.order,
            )
            | Q(page__article=self.page.article, page__order__gt=self.page.order)
            | Q(page=self.page, order__gt=self.order),
            **type_filter,
        ).order_by(
            "page__article__chapter__order",
            "page__article__order",
            "page__order",
            "order",
        )[:1]
        if following:
            block = following.first()
            block.number = block.calculate_number()
            block.save()


class BlockTranslation(models.Model):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    block = models.ForeignKey(Block, on_delete=models.CASCADE)
    title = models.CharField(max_length=150, blank=True)
    content = models.TextField()

    class Meta:
        db_table = "articles_block_translations"
        ordering = ["language"]

    def __str__(self):
        return f"{self.block}/{self.language}"

    def save(self, *args, **kwargs) -> None:  # noqa: ANN002, ANN003
        # Search for label, remove it from content afterwards
        label = re.search(r"\\label{(.*)}", self.content)
        if label and label.group(1).strip():
            self.block.ref_label = label.group(1).strip()
            self.block.save()
        self.content = re.sub(r"\\label{.*}", "", self.content)
        self.content = self.content.strip()
        # Replace end of paragraph with \break tag
        self.content = re.sub(r"(\r?\n){2,}", r" \\break ", self.content)
        # Filter out extra white spaces
        self.content = re.sub(r"[\n\r\t]", " ", self.content)
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

    class Meta:
        ordering = ["ref_name"]

    def __str__(self):
        return f"{self.ref_name}: {self.author}, {self.year}, {self.title}"


class LearnImage(models.Model):
    ref_name = models.CharField(max_length=50, unique=True)
    image = models.ImageField(upload_to="learn_images")

    class Meta:
        ordering = ["ref_name"]

    def __str__(self):
        return self.ref_name
