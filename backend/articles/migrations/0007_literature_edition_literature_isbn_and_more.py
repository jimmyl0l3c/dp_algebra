# Generated by Django 4.1.7 on 2023-03-20 16:59

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('articles', '0006_block_number_reflabel'),
    ]

    operations = [
        migrations.AddField(
            model_name='literature',
            name='edition',
            field=models.IntegerField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='literature',
            name='isbn',
            field=models.CharField(blank=True, max_length=18, null=True),
        ),
        migrations.AddField(
            model_name='literature',
            name='location',
            field=models.CharField(default='unknown', max_length=100),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='literature',
            name='pages',
            field=models.IntegerField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='literature',
            name='publisher',
            field=models.CharField(default='unknown', max_length=100),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='literature',
            name='title',
            field=models.CharField(default='unknown', max_length=100),
            preserve_default=False,
        ),
    ]
