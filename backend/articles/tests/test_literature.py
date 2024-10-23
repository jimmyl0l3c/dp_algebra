from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase

from articles.models import Literature


class LiteratureTest(APITestCase):
    @classmethod
    def setUpTestData(cls):
        for i, ref in enumerate({"foo", "bar", "baz", "qux"}):
            Literature.objects.create(
                ref_name=ref, title=f'{ref}-title', author=f'{ref}-author', year=f'202{i}',
                location=f"{ref} place", publisher=f"self {ref}"
            )

    def test_literature_list(self):
        url = reverse('literature-list')
        response = self.client.get(url, format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 4)