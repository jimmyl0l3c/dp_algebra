# Generated by Django 4.1.7 on 2023-02-27 15:16

import django.db.models.deletion
from django.db import migrations, models


def add_default_block_type(apps, schema_editor):
    BlockType = apps.get_model("articles", "BlockType")
    block = BlockType(enumerated=False)
    block.save()


class Migration(migrations.Migration):
    dependencies = [
        ("articles", "0001_initial"),
    ]

    operations = [
        migrations.CreateModel(
            name="BlockType",
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
                ("enumerated", models.BooleanField(db_index=True)),
            ],
        ),
        migrations.AlterModelOptions(
            name="article",
            options={"ordering": ["order"]},
        ),
        migrations.AlterModelOptions(
            name="block",
            options={"ordering": ["order"]},
        ),
        migrations.AlterModelOptions(
            name="chapter",
            options={"ordering": ["order"]},
        ),
        migrations.AlterModelOptions(
            name="page",
            options={"ordering": ["order"]},
        ),
        migrations.AddField(
            model_name="blocktranslation",
            name="title",
            field=models.CharField(blank=True, max_length=150),
        ),
        migrations.CreateModel(
            name="BlockTypeTranslation",
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
                ("title", models.CharField(max_length=100)),
                (
                    "block_type",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="articles.blocktype",
                    ),
                ),
                (
                    "language",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="articles.language",
                    ),
                ),
            ],
        ),
        migrations.RunPython(add_default_block_type),
        migrations.AddField(
            model_name="block",
            name="type",
            field=models.ForeignKey(
                default=1,
                on_delete=django.db.models.deletion.CASCADE,
                to="articles.blocktype",
            ),
            preserve_default=False,
        ),
    ]
