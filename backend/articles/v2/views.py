from django.db.models import Prefetch, QuerySet
from django.utils import translation
from django.utils.translation import gettext_lazy as _
from rest_framework import generics
from rest_framework.exceptions import NotFound

from articles.models import (
    Article,
    ArticleTranslation,
    Block,
    BlockType,
    BlockTypeTranslation,
    Chapter,
    ChapterTranslation,
    Literature,
    Page,
)
from articles.v2.serializers import (
    ArticleTranslationSerializer,
    BlockTypeSerializer,
    ChapterTranslationSerializer,
    LiteratureSerializer,
    PageSerializer,
)


class LiteratureListView(generics.ListAPIView):
    queryset = Literature.objects.all()
    serializer_class = LiteratureSerializer


class LiteratureDetailView(generics.RetrieveAPIView):
    queryset = Literature.objects.all()
    serializer_class = LiteratureSerializer
    lookup_field = "ref_name"


class ChapterListView(generics.ListAPIView):
    queryset = ChapterTranslation.objects.all()
    serializer_class = ChapterTranslationSerializer

    def get_queryset(self) -> QuerySet:
        lang_code = translation.get_language()
        return (
            self.__class__.queryset.select_related("chapter")
            .filter(language__code__iexact=lang_code)
            .all()
            .order_by("chapter__order")
        )


class ChapterDetailView(generics.ListAPIView):
    queryset = ArticleTranslation.objects.all()
    serializer_class = ArticleTranslationSerializer

    def get_queryset(self) -> QuerySet:
        if not (chapter := Chapter.objects.filter(pk=(pk := self.kwargs.get("pk")))).exists():
            raise NotFound(_("Chapter %(pk)s not found") % {"pk": pk})
        lang_code = translation.get_language()
        return (
            self.__class__.queryset.select_related("article")
            .filter(language__code__iexact=lang_code, article__chapter=chapter.get())
            .all()
            .order_by("article__order")
        )


class BlockTypeView(generics.ListAPIView):
    queryset = BlockType.objects.all()
    serializer_class = BlockTypeSerializer

    def get_queryset(self) -> QuerySet:
        lang_code = translation.get_language()
        return (
            self.__class__.queryset.prefetch_related(
                Prefetch(
                    "blocktypetranslation_set",
                    queryset=BlockTypeTranslation.objects.filter(language__code__iexact=lang_code),
                )
            )
            .all()
            .order_by("pk")
        )


class ArticlePageListView(generics.ListAPIView):
    queryset = Page.objects.all()
    serializer_class = PageSerializer

    def get_queryset(self) -> QuerySet:
        if not (article := Article.objects.filter(pk=(pk := self.kwargs.get("pk")))).exists():
            raise NotFound(_("Article %(pk)s not found") % {"pk": pk})
        lang_code = translation.get_language()
        return (
            self.__class__.queryset.prefetch_related(
                Prefetch(
                    "block_set",
                    queryset=Block.objects.prefetch_related("blocktranslation_set")
                    .filter(blocktranslation__language__code__iexact=lang_code)
                    .all()
                    .order_by("order"),
                    to_attr="block_translation",
                ),
            )
            .filter(article=article.get())
            .order_by("order")
        )
