# Generated by Django 4.1.7 on 2023-02-27 17:39

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('articles', '0004_literature'),
    ]

    operations = [
        migrations.AlterField(
            model_name='literature',
            name='ref_name',
            field=models.CharField(max_length=50, unique=True),
        ),
    ]