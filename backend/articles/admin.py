from django.contrib import admin
from .models import Language, Chapter, ChapterTranslation, Article, ArticleTranslation, Page, Block, BlockTranslation, \
    BlockType, BlockTypeTranslation, Literature, RefLabel


class InlineChapterTranslation(admin.TabularInline):
    model = ChapterTranslation
    extra = 1


@admin.register(Chapter)
class ChapterAdmin(admin.ModelAdmin):
    list_display = ('__str__', 'order')
    inlines = [InlineChapterTranslation]


class InlineArticleTranslation(admin.TabularInline):
    model = ArticleTranslation
    extra = 1


@admin.register(Article)
class ArticleAdmin(admin.ModelAdmin):
    list_display = ('__str__', 'chapter', 'order')
    inlines = [InlineArticleTranslation]


class InlineBlockTranslation(admin.StackedInline):
    model = BlockTranslation
    extra = 1


@admin.register(Block)
class BlockAdmin(admin.ModelAdmin):
    list_display = ('page', 'id', 'order', 'number')
    inlines = [InlineBlockTranslation]
    readonly_fields = ['number']


class InlineBlockTypeTranslation(admin.TabularInline):
    model = BlockTypeTranslation
    extra = 1


@admin.register(BlockType)
class BlockTypeAdmin(admin.ModelAdmin):
    list_display = ( '__str__', 'id', 'show_title', 'enumerated')
    inlines = [InlineBlockTypeTranslation]


@admin.register(Page)
class PageAdmin(admin.ModelAdmin):
    list_display = ('article', 'id', 'order')


@admin.register(RefLabel)
class RefLabelAdmin(admin.ModelAdmin):
    list_display = ('ref_name', 'block')


@admin.register(Literature)
class LiteratureAdmin(admin.ModelAdmin):
    list_display = ('ref_name', '__str__')


@admin.register(Language)
class LanguageAdmin(admin.ModelAdmin):
    list_display = ('code', 'name')


admin.site.site_header = 'Algebra - Administration'
admin.site.site_title = 'Algebra'
