import os.path

from django.db.models import F
from django.http import HttpRequest, JsonResponse, FileResponse
from django.views.decorators.http import require_http_methods

from algebra_api.settings import MEDIA_ROOT
from articles.models import Chapter, Article, Block, Literature, RefLabel, LearnImage


@require_http_methods(["GET"])
def chapters_view(request: HttpRequest, locale_id: int):
    chapters = Chapter.objects.filter(chaptertranslation__language=locale_id).values(
        chapter_id=F('id'),
        chapter_title=F('chaptertranslation__title'),
        chapter_description=F('chaptertranslation__description')
    )
    return JsonResponse({'chapters': list(chapters)})


@require_http_methods(["GET"])
def chapter_view(request: HttpRequest, locale_id: int, chapter_id: int):
    chapter = Chapter.objects.filter(id=chapter_id, chaptertranslation__language=locale_id).values(
        chapter_id=F('id'),
        chapter_title=F('chaptertranslation__title'),
        chapter_description=F('chaptertranslation__description')
    )

    if not chapter.exists():
        return JsonResponse({'error': 'Chapter not found'}, status=404)

    articles = Article.objects.filter(chapter=chapter_id, articletranslation__language=locale_id).values(
        article_id=F('id'),
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
        'chapter_id',
        chapter_title=F('chapter__chaptertranslation__title'),
        article_id=F('id'),  # TODO: remove, unnecessary
        article_title=F('articletranslation__title'),
    )

    if not article.exists():
        return JsonResponse({'error': 'Article not found'}, status=404)

    blocks = list(Block.objects.filter(
        page__article=article_id,
        blocktranslation__language=locale_id,
        type__blocktypetranslation__language=locale_id
    ).values(
        page_index=F('page__order'),
        block_number=F('number'),
        block_type_visible=F('type__show_title'),
        block_type_title=F('type__blocktypetranslation__title'),
        block_title=F('blocktranslation__title'),
        block_content=F('blocktranslation__content')
    ).order_by('order', 'page_index'))

    pages = []
    for block in blocks:
        if block['page_index'] == len(pages):
            pages.append([])
        pages[block['page_index']].append(block)

    return JsonResponse({**article.get(), 'pages': pages})


@require_http_methods(["GET"])
def get_literature_view(request: HttpRequest):
    if 'ref_name' in request.GET:
        lit = Literature.objects.filter(ref_name__iexact=request.GET['ref_name']).values()

        if not lit.exists():
            return JsonResponse({'error': 'Literature not found'}, status=404)

        return JsonResponse({**lit.get()})
    else:
        return JsonResponse({'literature': list(Literature.objects.all().values())})


@require_http_methods(["GET"])
def get_reference_view(request: HttpRequest):
    values_args = ['ref_name']
    values_kwargs = {
        "block_type": F('block__type'),
        "block_number": F('block__number'),
        "page": F('block__page__order'),
        "article": F('block__page__article'),
        "chapter": F('block__page__article__chapter')
    }

    if 'ref_name' in request.GET:
        ref = RefLabel.objects.filter(ref_name__iexact=request.GET['ref_name']).values(*values_args, **values_kwargs)

        if not ref.exists():
            return JsonResponse({'error': 'Reference not found'}, status=404)

        return JsonResponse({**ref.get()})
    else:
        return JsonResponse({'reference': list(RefLabel.objects.all().values(*values_args, **values_kwargs))})


@require_http_methods(['GET'])
def get_learn_image_view(request: HttpRequest):
    if 'ref_name' not in request.GET:
        return JsonResponse({'error': 'Image ref not specified'})
    image_path_q = LearnImage.objects.filter(ref_name__iexact=request.GET['ref_name']).values('image')
    if image_path_q.exists():  # Check if the image is in the database
        image_path = os.path.join(MEDIA_ROOT, image_path_q.get()['image'])
        if os.path.exists(image_path):  # Check if the image file exists
            return FileResponse(open(image_path, 'rb'))
    return JsonResponse({'error': 'Image not found'})
