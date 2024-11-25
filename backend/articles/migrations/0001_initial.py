# Generated by Django 5.1.2 on 2024-10-23 17:45

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='BlockType',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('show_title', models.BooleanField(db_index=True)),
                ('enumerated', models.BooleanField(db_index=True)),
                ('figure', models.BooleanField(db_index=True)),
                ('code', models.CharField(max_length=50, unique=True)),
            ],
            options={
                'ordering': ['id'],
            },
        ),
        migrations.CreateModel(
            name='Chapter',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('order', models.BigIntegerField(db_index=True)),
            ],
            options={
                'ordering': ['order'],
            },
        ),
        migrations.CreateModel(
            name='Language',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('code', models.CharField(max_length=5, unique=True)),
                ('name', models.CharField(max_length=150)),
            ],
            options={
                'ordering': ['code'],
            },
        ),
        migrations.CreateModel(
            name='LearnImage',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ref_name', models.CharField(max_length=50, unique=True)),
                ('image', models.ImageField(upload_to='learn_images')),
            ],
            options={
                'ordering': ['ref_name'],
            },
        ),
        migrations.CreateModel(
            name='Literature',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ref_name', models.CharField(max_length=50, unique=True)),
                ('author', models.CharField(max_length=150)),
                ('year', models.CharField(max_length=10)),
                ('title', models.CharField(max_length=100)),
                ('location', models.CharField(max_length=100)),
                ('publisher', models.CharField(max_length=100)),
                ('isbn', models.CharField(blank=True, max_length=18, null=True)),
                ('edition', models.IntegerField(blank=True, null=True)),
                ('pages', models.IntegerField(blank=True, null=True)),
            ],
            options={
                'ordering': ['ref_name'],
            },
        ),
        migrations.CreateModel(
            name='Block',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('order', models.BigIntegerField(db_index=True)),
                ('number', models.PositiveIntegerField(blank=True, null=True)),
                ('ref_label', models.CharField(blank=True, max_length=50, null=True, unique=True)),
                ('type', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.blocktype')),
            ],
            options={
                'ordering': ['page__article__chapter__order', 'page__article__order', 'page__order', 'order'],
            },
        ),
        migrations.CreateModel(
            name='Article',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('order', models.BigIntegerField(db_index=True)),
                ('published_at', models.DateField()),
                ('chapter', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.chapter')),
            ],
            options={
                'ordering': ['chapter__order', 'order'],
            },
        ),
        migrations.CreateModel(
            name='ChapterTranslation',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=150)),
                ('description', models.CharField(blank=True, max_length=250)),
                ('chapter', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.chapter')),
                ('language', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.language')),
            ],
            options={
                'db_table': 'articles_chapter_translations',
                'ordering': ['language'],
            },
        ),
        migrations.CreateModel(
            name='BlockTypeTranslation',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=100)),
                ('block_type', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.blocktype')),
                ('language', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.language')),
            ],
            options={
                'ordering': ['language'],
            },
        ),
        migrations.CreateModel(
            name='BlockTranslation',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(blank=True, max_length=150)),
                ('content', models.TextField()),
                ('block', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.block')),
                ('language', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.language')),
            ],
            options={
                'db_table': 'articles_block_translations',
                'ordering': ['language'],
            },
        ),
        migrations.CreateModel(
            name='ArticleTranslation',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=150)),
                ('description', models.CharField(blank=True, max_length=250)),
                ('article', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.article')),
                ('language', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.language')),
            ],
            options={
                'db_table': 'articles_article_translations',
                'ordering': ['language'],
            },
        ),
        migrations.CreateModel(
            name='Page',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('order', models.BigIntegerField(db_index=True)),
                ('article', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.article')),
            ],
            options={
                'ordering': ['article__chapter__order', 'article__order', 'order'],
            },
        ),
        migrations.AddField(
            model_name='block',
            name='page',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.page'),
        ),
    ]
