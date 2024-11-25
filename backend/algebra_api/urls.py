"""algebra_api URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/

"""

from django.contrib import admin
from django.urls import include, path
from rest_framework import permissions
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.reverse import reverse
from rest_framework.views import APIView


class APIRootView(APIView):
    permission_classes = (permissions.AllowAny,)

    def get(self, request: Request) -> Response:
        return Response(
            {
                "Learn API v2": reverse("learn-root", request=request),
            }
        )


urlpatterns = [
    path("", APIRootView.as_view(), name="api-root"),
    path("api/learn/", include("articles.urls")),
    path("learn/", include("articles.v2.urls")),
    path("admin/", admin.site.urls),
]
