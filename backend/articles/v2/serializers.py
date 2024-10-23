from rest_framework import serializers

from articles.models import ArticleTranslation, ChapterTranslation, Literature


class LiteratureSerializer(serializers.ModelSerializer):
    class Meta:
        model = Literature
        fields = "__all__"


class ChapterTranslationSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChapterTranslation
        exclude = ("id", "language")


class ArticleTranslationSerializer(serializers.ModelSerializer):
    # TODO: add chapter detail?
    class Meta:
        model = ArticleTranslation
        exclude = ("id", "language")
