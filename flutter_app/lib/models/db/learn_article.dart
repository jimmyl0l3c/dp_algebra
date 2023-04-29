import 'learn_page.dart';

class LArticle {
  final int id;
  final String title;
  final String? description;
  List<LPage> pages;

  LArticle(this.id, this.title, this.pages, {this.description});

  LArticle.fromJson(Map<dynamic, dynamic> json)
      : id = json['article_id'],
        title = json['article_title'],
        description = json.containsKey('article_description') &&
                json['article_description'].isNotEmpty
            ? json['article_description']
            : null,
        pages = json.containsKey('pages') ? _pagesFromJson(json['pages']) : [];

  static List<LPage> _pagesFromJson(List<dynamic> pages) =>
      pages.map((p) => LPage.fromJson(p)).toList();
}
