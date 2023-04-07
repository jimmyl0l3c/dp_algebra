# Generated by Django 4.1.7 on 2023-03-18 12:43

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):
    dependencies = [
        ("articles", "0005_alter_literature_ref_name"),
    ]

    operations = [
        migrations.AddField(
            model_name="block",
            name="number",
            field=models.PositiveIntegerField(blank=True, null=True),
        ),
        migrations.CreateModel(
            name="RefLabel",
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
                (
                    "block",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE, to="articles.block"
                    ),
                ),
            ],
        ),
    ]
