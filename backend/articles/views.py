from django.db.models import F, Count
from django.http import HttpRequest, JsonResponse
from django.views.decorators.http import require_http_methods

from articles.models import Chapter, Article, Block, Page


@require_http_methods(["GET"])
def chapters_view(request: HttpRequest, locale_id: int):
    chapters = Chapter.objects.filter(chaptertranslation__language=locale_id).values(
        'id',
        chapter_title=F('chaptertranslation__title'),
        chapter_description=F('chaptertranslation__description')
    )
    return JsonResponse({'chapters': list(chapters)})


@require_http_methods(["GET"])
def chapter_view(request: HttpRequest, locale_id: int, chapter_id: int):
    chapter = Chapter.objects.filter(id=chapter_id, chaptertranslation__language=locale_id).values(
        chapter_title=F('chaptertranslation__title'),
        chapter_description=F('chaptertranslation__description')
    )

    if not chapter.exists():
        return JsonResponse({'error': 'Chapter not found'}, status=404)

    articles = Article.objects.filter(chapter=chapter_id, articletranslation__language=locale_id).values(
        article_title=F('articletranslation__title'),
        article_description=F('articletranslation__description')
    )

    return JsonResponse({**chapter.get(), 'articles': list(articles)})


@require_http_methods(["GET"])
def article_view(request: HttpRequest, locale_id: int, article_id: int):
    article = Article.objects.filter(
        id=article_id,
        chapter__chaptertranslation__language=locale_id,
        articletranslation__language=locale_id,
    ).values(
        chapter_title=F('chapter__chaptertranslation__title'),
        article_title=F('articletranslation__title'),
    ).annotate(page_count=Count('page'))

    if not article.exists():
        return JsonResponse({'error': 'Article not found'}, status=404)

    if 'page_id' in request.GET and request.GET['page_id'].isnumeric():
        page_id = int(request.GET['page_id'])
    else:
        first_page = Page.objects.filter(article_id=article_id).order_by('order').values('id')[:1]
        page_id = first_page.get()['id'] if first_page.exists() else None

    if page_id:
        blocks = Block.objects.filter(
            page__article=article_id, page=page_id, blocktranslation__language=locale_id
        ).values(
            block_content=F('blocktranslation__content')
        )
        page = list(blocks)
    else:
        page = []
    return JsonResponse({**article.get(), 'page_blocks': page})
