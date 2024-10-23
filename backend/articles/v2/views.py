from rest_framework import generics

from articles.models import Literature
from articles.v2.serializers import LiteratureSerializer


class LiteratureListView(generics.ListAPIView):
    queryset = Literature.objects.all()
    serializer_class = LiteratureSerializer


class LiteratureDetailView(generics.RetrieveAPIView):
    queryset = Literature.objects.all()
    serializer_class = LiteratureSerializer
    lookup_field = "ref_name"