from rest_framework import serializers

from articles.models import ArticleTranslation, Block, BlockType, ChapterTranslation, Literature, Page


class LiteratureSerializer(serializers.ModelSerializer):
    class Meta:
        model = Literature
        fields = "__all__"


class ChapterTranslationSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChapterTranslation
        exclude = ("id", "language")


class ArticleTranslationSerializer(serializers.ModelSerializer):
    class Meta:
        model = ArticleTranslation
        exclude = ("id", "language")


class BlockTypeSerializer(serializers.ModelSerializer):
    title = serializers.SlugRelatedField("title", read_only=True, many=True, source="blocktypetranslation_set")

    def to_representation(self, instance: BlockType) -> dict:
        representation = super().to_representation(instance)
        representation["title"] = representation["title"][0] if representation["title"] else None
        return representation

    class Meta:
        model = BlockType
        fields = "__all__"


class BlockSerializer(serializers.ModelSerializer):
    title = serializers.SlugRelatedField("title", read_only=True, many=True, source="blocktranslation_set")
    content = serializers.SlugRelatedField("content", read_only=True, many=True, source="blocktranslation_set")

    def to_representation(self, instance: Block) -> dict:
        representation = super().to_representation(instance)
        representation["title"] = representation["title"][0] if representation["title"] else None
        representation["content"] = representation["content"][0] if representation["content"] else None
        return representation

    class Meta:
        model = Block
        exclude = ("page",)


class PageSerializer(serializers.ModelSerializer):
    blocks = BlockSerializer(many=True, read_only=True, source="block_translation")

    class Meta:
        model = Page
        exclude = ("article",)
