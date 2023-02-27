from django.contrib import admin
from .models import Language, Chapter, ChapterTranslation, Article, ArticleTranslation, Page, Block, BlockTranslation, \
    BlockType, BlockTypeTranslation, Literature


class InlineChapterTranslation(admin.TabularInline):
    model = ChapterTranslation
    extra = 1


@admin.register(Chapter)
class ChapterAdmin(admin.ModelAdmin):
    inlines = [InlineChapterTranslation]


class InlineArticleTranslation(admin.TabularInline):
    model = ArticleTranslation
    extra = 1


@admin.register(Article)
class ArticleAdmin(admin.ModelAdmin):
    inlines = [InlineArticleTranslation]


class InlineBlockTranslation(admin.StackedInline):
    model = BlockTranslation
    extra = 1


@admin.register(Block)
class BlockAdmin(admin.ModelAdmin):
    inlines = [InlineBlockTranslation]


class InlineBlockTypeTranslation(admin.TabularInline):
    model = BlockTypeTranslation
    extra = 1


@admin.register(BlockType)
class BlockTypeAdmin(admin.ModelAdmin):
    inlines = [InlineBlockTypeTranslation]


admin.site.register(Language)
admin.site.register(Page)
admin.site.register(Literature)

admin.site.site_header = 'Algebra - Administration'
admin.site.site_title = 'Algebra'
