import 'learn_page.dart';

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
      : id = json["id"],
        order = json["order"],
        chapterId = json["chapterId"] ?? manChapterId,
        title = json["title"],
        description = json["description"],
        pages = json.containsKey("pages") ? _pagesFromJson(json["pages"]) : [];

  static List<LPage> _pagesFromJson(List<Map<dynamic, dynamic>> pages) =>
      pages.map((p) => LPage.fromJson(p)).toList();
}
