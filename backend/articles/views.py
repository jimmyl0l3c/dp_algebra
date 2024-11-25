from django.db.models import F
from django.http import FileResponse, HttpRequest, JsonResponse
from django.views.decorators.http import require_http_methods

from algebra_api.settings import MEDIA_ROOT
from articles.models import Article, Block, Chapter, LearnImage, Literature


@require_http_methods(["GET"])
def chapters_view(request: HttpRequest, locale_id: int) -> JsonResponse:  # noqa: ARG001
    chapters = Chapter.objects.filter(chaptertranslation__language=locale_id).values(
        chapter_id=F("id"),
        chapter_title=F("chaptertranslation__title"),
        chapter_description=F("chaptertranslation__description"),
    )
    return JsonResponse({"chapters": list(chapters)})


@require_http_methods(["GET"])
def chapter_view(request: HttpRequest, locale_id: int, chapter_id: int) -> JsonResponse:  # noqa: ARG001
    chapter = Chapter.objects.filter(id=chapter_id, chaptertranslation__language=locale_id).values(
        chapter_id=F("id"),
        chapter_title=F("chaptertranslation__title"),
        chapter_description=F("chaptertranslation__description"),
    )

    if not chapter.exists():
        return JsonResponse({"error": "Chapter not found"}, status=404)

    articles = Article.objects.filter(chapter=chapter_id, articletranslation__language=locale_id).values(
        article_id=F("id"),
        article_title=F("articletranslation__title"),
        article_description=F("articletranslation__description"),
    )

    return JsonResponse({**chapter.get(), "articles": list(articles)})


@require_http_methods(["GET"])
def article_view(request: HttpRequest, locale_id: int, article_id: int) -> JsonResponse:  # noqa: ARG001
    article = Article.objects.filter(
        id=article_id,
        chapter__chaptertranslation__language=locale_id,
        articletranslation__language=locale_id,
    ).values(
        "chapter_id",
        chapter_title=F("chapter__chaptertranslation__title"),
        article_id=F("id"),  # TODO: remove, unnecessary, # noqa: FIX002
        article_title=F("articletranslation__title"),
    )

    if not article.exists():
        return JsonResponse({"error": "Article not found"}, status=404)

    blocks = list(
        Block.objects.filter(
            page__article=article_id,
            blocktranslation__language=locale_id,
            type__blocktypetranslation__language=locale_id,
        )
        .values(
            page_index=F("page__order"),
            block_number=F("number"),
            block_type_visible=F("type__show_title"),
            block_type_title=F("type__blocktypetranslation__title"),
            block_type_code=F("type__code"),
            block_title=F("blocktranslation__title"),
            block_content=F("blocktranslation__content"),
        )
        .order_by("page_index", "order")
    )

    pages, curr_page = [], -1
    for block in blocks:
        if block["page_index"] != curr_page:
            curr_page = block["page_index"]
            pages.append([])
        pages[-1].append(block)

    return JsonResponse({**article.get(), "pages": pages})


@require_http_methods(["GET"])
def get_literature_view(request: HttpRequest) -> JsonResponse:
    if "ref_name" in request.GET:
        lit = Literature.objects.filter(ref_name__iexact=request.GET["ref_name"]).values()

        if not lit.exists():
            return JsonResponse({"error": "Literature not found"}, status=404)

        return JsonResponse({**lit.get()})
    return JsonResponse({"literature": list(Literature.objects.all().values())})


@require_http_methods(["GET"])
def get_reference_view(request: HttpRequest) -> JsonResponse:
    is_filtered = "ref_name" in request.GET
    if is_filtered:
        ref = Block.objects.filter(ref_label__iexact=request.GET["ref_name"])

        if not ref.exists():
            return JsonResponse({"error": "Reference not found"}, status=404)
    else:
        ref = Block.objects.filter(ref_label__isnull=False)

    ref = ref.values(
        "ref_label",
        block_type=F("type"),
        block_number=F("number"),
        page_order=F("page__order"),
        article=F("page__article"),
        chapter=F("page__article__chapter"),
    )

    return JsonResponse({**ref.get()} if is_filtered else {"reference": list(ref)})


@require_http_methods(["GET"])
def get_learn_image_view(request: HttpRequest, ref_name: str) -> FileResponse | JsonResponse:  # noqa: ARG001
    image_path_q = LearnImage.objects.filter(ref_name__iexact=ref_name).values("image")

    if image_path_q.exists():  # Check if the image is in the database
        image_path = MEDIA_ROOT / image_path_q.get()["image"]
        if image_path.exists():  # Check if the image file exists
            return FileResponse(image_path.open("rb"))

    return JsonResponse({"error": "Image not found"}, status=404)
