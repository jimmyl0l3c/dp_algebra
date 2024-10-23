from django.db.models import QuerySet
from django.utils import translation
from django.utils.translation import gettext_lazy as _
from rest_framework import generics
from rest_framework.exceptions import NotFound

from articles.models import ArticleTranslation, Chapter, ChapterTranslation, Literature
from articles.v2.serializers import ArticleTranslationSerializer, ChapterTranslationSerializer, LiteratureSerializer


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
        if lang_code := translation.get_language():
            return ChapterTranslation.objects.filter(language__code__iexact=lang_code).all()
        return self.__class__.queryset


class ChapterDetailView(generics.ListAPIView):
    queryset = ArticleTranslation.objects.all()
    serializer_class = ArticleTranslationSerializer

    def get_queryset(self) -> QuerySet:
        if not (chapter := Chapter.objects.filter(pk=(pk := self.kwargs.get("pk")))).exists():
            raise NotFound(_("Chapter %(pk)s not found") % {"pk": pk})
        queryset = self.__class__.queryset
        if lang_code := translation.get_language():
            queryset = ArticleTranslation.objects.filter(language__code__iexact=lang_code).all()
        return queryset.filter(article__chapter=chapter.get())
