from django.contrib import admin
from .models import Language, Chapter, ChapterTranslation, Article, ArticleTranslation, Page, Block, BlockTranslation

admin.site.register(Language)
admin.site.register(Chapter)
admin.site.register(ChapterTranslation)
admin.site.register(Article)
admin.site.register(ArticleTranslation)
admin.site.register(Page)
admin.site.register(Block)
admin.site.register(BlockTranslation)
