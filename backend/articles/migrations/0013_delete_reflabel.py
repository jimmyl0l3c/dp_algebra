# Generated by Django 4.1.7 on 2023-04-17 19:54

from django.db import migrations


class Migration(migrations.Migration):
    dependencies = [
        ("articles", "0012_alter_article_options_and_more"),
    ]

    operations = [
        migrations.DeleteModel(
            name="RefLabel",
        ),
    ]
