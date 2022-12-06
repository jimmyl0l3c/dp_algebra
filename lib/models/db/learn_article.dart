import 'package:dp_algebra/models/db/learn_page.dart';

class LArticle {
  final int id;
  final String title;
  final String? description;
  List<LPage> pages;
  final int chapterId;
  final int order;

  LArticle(this.id, this.order, this.title, this.pages, this.chapterId,
      {this.description});

  LArticle.fromJson(Map<dynamic, dynamic> json, {int manChapterId = -1})
      : id = json["article_id"],
        order = json["order"],
        chapterId = json["chapterId"] != null
            ? (json["chapterId"]["chapter_id"] ?? manChapterId)
            : manChapterId,
        title = json["title"],
        description = json["description"],
        pages = json.containsKey("pages")
            ? _pagesFromJson(json["pages"], json["article_id"])
            : [];

  static List<LPage> _pagesFromJson(List<dynamic> pages, int id) =>
      pages.map((p) => LPage.fromJson(p, manArticleId: id)).toList();
}
