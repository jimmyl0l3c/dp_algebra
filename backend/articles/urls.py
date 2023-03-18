from django.urls import path

from . import views

urlpatterns = [
    path('<int:locale_id>/chapter/', views.chapters_view),
    path('<int:locale_id>/chapter/<int:chapter_id>', views.chapter_view),
    path('<int:locale_id>/article/<int:article_id>', views.article_view),
    path('literature', views.get_literature_view),
    path('ref', views.get_reference_view),
]
