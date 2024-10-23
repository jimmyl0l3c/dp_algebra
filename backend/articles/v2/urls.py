from django.urls import path

from . import views

urlpatterns = [
    path("literature/", views.LiteratureListView.as_view(), name="literature-list"),
    path("literature/<slug:ref_name>/", views.LiteratureDetailView.as_view(), name="literature-detail"),
]
