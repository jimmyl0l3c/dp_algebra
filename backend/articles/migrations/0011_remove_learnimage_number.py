# Generated by Django 4.1.7 on 2023-04-01 11:42

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('articles', '0010_blocktype_figure'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='learnimage',
            name='number',
        ),
    ]