# Generated by Django 4.1.7 on 2023-02-26 16:18

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Article',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('order', models.BigIntegerField(db_index=True)),
                ('published_at', models.DateField()),
            ],
        ),
        migrations.CreateModel(
            name='Block',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('order', models.BigIntegerField(db_index=True)),
            ],
        ),
        migrations.CreateModel(
            name='Chapter',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('order', models.BigIntegerField(db_index=True)),
            ],
        ),
        migrations.CreateModel(
            name='Language',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('code', models.CharField(max_length=5, unique=True)),
                ('name', models.CharField(max_length=150)),
            ],
        ),
        migrations.CreateModel(
            name='Page',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('order', models.BigIntegerField(db_index=True)),
                ('article', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.article')),
            ],
        ),
        migrations.CreateModel(
            name='ChapterTranslations',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=150)),
                ('description', models.CharField(max_length=250)),
                ('chapter', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.chapter')),
                ('language', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.language')),
            ],
        ),
        migrations.CreateModel(
            name='BlockTranslations',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('content', models.TextField()),
                ('block', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.block')),
                ('language', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.language')),
            ],
        ),
        migrations.AddField(
            model_name='block',
            name='page',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.page'),
        ),
        migrations.CreateModel(
            name='ArticleTranslations',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=150)),
                ('description', models.CharField(max_length=250)),
                ('article', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.article')),
                ('language', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.language')),
            ],
        ),
        migrations.AddField(
            model_name='article',
            name='chapter',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.chapter'),
        ),
    ]
