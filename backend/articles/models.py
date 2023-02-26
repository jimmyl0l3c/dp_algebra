from django.db import models


class Language(models.Model):
    code = models.CharField(max_length=5, unique=True)
    name = models.CharField(max_length=150)


class Chapter(models.Model):
    order = models.BigIntegerField(db_index=True)


class ChapterTranslation(models.Model):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE)
    title = models.CharField(max_length=150)
    description = models.CharField(max_length=250)

    class Meta:
        db_table = 'articles_chapter_translations'


class Article(models.Model):
    order = models.BigIntegerField(db_index=True)
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE)
    published_at = models.DateField()


class ArticleTranslation(models.Model):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    article = models.ForeignKey(Article, on_delete=models.CASCADE)
    title = models.CharField(max_length=150)
    description = models.CharField(max_length=250)

    class Meta:
        db_table = 'articles_article_translations'


class Page(models.Model):
    order = models.BigIntegerField(db_index=True)
    article = models.ForeignKey(Article, on_delete=models.CASCADE)


class Block(models.Model):
    order = models.BigIntegerField(db_index=True)
    page = models.ForeignKey(Page, on_delete=models.CASCADE)


class BlockTranslation(models.Model):
    language = models.ForeignKey(Language, on_delete=models.CASCADE)
    block = models.ForeignKey(Block, on_delete=models.CASCADE)
    content = models.TextField()

    class Meta:
        db_table = 'articles_block_translations'
