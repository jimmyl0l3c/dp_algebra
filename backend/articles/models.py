from django.db import models


class Language(models.Model):
    code = models.CharField(max_length=5, unique=True)
    name = models.CharField(max_length=150)


class Chapter(models.Model):
    order = models.BigIntegerField(db_index=True)


class ChapterTranslations(models.Model):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE)
    title = models.CharField(max_length=150)
    description = models.CharField(max_length=250)


class Article(models.Model):
    order = models.BigIntegerField(db_index=True)
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE)
    published_at = models.DateField()


class ArticleTranslations(models.Model):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    article = models.ForeignKey(Article, on_delete=models.CASCADE)
    title = models.CharField(max_length=150)
    description = models.CharField(max_length=250)


class Page(models.Model):
    order = models.BigIntegerField(db_index=True)
    article = models.ForeignKey(Article, on_delete=models.CASCADE)


class Block(models.Model):
    order = models.BigIntegerField(db_index=True)
    page = models.ForeignKey(Page, on_delete=models.CASCADE)


class BlockTranslations(models.Model):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    block = models.ForeignKey(Block, on_delete=models.CASCADE)
    content = models.TextField()

