import 'learn_article.dart';

class LChapter {
  final int id;
  final String title;
  final String? description;
  List<LArticle> articles;

  LChapter(this.id, this.title, this.articles, {this.description});

  LChapter.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"],
        title = json["title"],
        description = json["description"],
        articles = json.containsKey("articles")
            ? _articlesFromJson(json["articles"], json["id"])
            : [];

  static List<LArticle> _articlesFromJson(List<dynamic> articles, int id) =>
      articles.map((a) => LArticle.fromJson(a!, manChapterId: id)).toList();
}
