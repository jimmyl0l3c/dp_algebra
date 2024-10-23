from rest_framework import serializers

from articles.models import Literature


class LiteratureSerializer(serializers.ModelSerializer):
    class Meta:
        model = Literature
        fields = '__all__'