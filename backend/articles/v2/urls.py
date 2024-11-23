from django.urls import path
from rest_framework import permissions
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.reverse import reverse
from rest_framework.views import APIView

from . import views


class LearnRootView(APIView):
    permission_classes = (permissions.AllowAny,)

    def get(self, request: Request) -> Response:
        return Response({
            "Literature list": reverse("literature-list", request=request),
            "Chapter list": reverse("chapter-list", request=request),
        })

urlpatterns = [
    path("", LearnRootView.as_view(), name="learn-root"),
    path("literature/", views.LiteratureListView.as_view(), name="literature-list"),
    path("literature/<slug:ref_name>/", views.LiteratureDetailView.as_view(), name="literature-detail"),
    path("chapter/", views.ChapterListView.as_view(), name="chapter-list"),
    path("chapter/<int:pk>/", views.ChapterDetailView.as_view(), name="chapter-detail"),
]
