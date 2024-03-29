# Generated by Django 4.1.7 on 2023-03-22 19:57

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("articles", "0007_literature_edition_literature_isbn_and_more"),
    ]

    operations = [
        migrations.CreateModel(
            name="LearnImage",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("ref_name", models.CharField(max_length=50, unique=True)),
                ("image", models.ImageField(upload_to="learn_images")),
            ],
        ),
    ]
