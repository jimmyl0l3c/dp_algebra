# Generated by Django 4.1.7 on 2023-02-26 16:28

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('articles', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='blocktranslation',
            table='articles_block_translations',
        ),
        migrations.AlterModelTable(
            name='chaptertranslation',
            table='articles_chapter_translations',
        ),
    ]
