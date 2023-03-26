import 'learn_article.dart';

class LChapter {
  final int id;
  final String title;
  final String? description;
  List<LArticle> articles;

  LChapter(this.id, this.title, this.articles, {this.description});

  LChapter.fromJson(Map<dynamic, dynamic> json)
      : id = json["chapter_id"],
        title = json["chapter_title"],
        description = json.containsKey("chapter_description") &&
                json["chapter_description"].isNotEmpty
            ? json["chapter_description"]
            : null,
        articles = json.containsKey("articles")
            ? _articlesFromJson(json["articles"])
            : [];

  static List<LArticle> _articlesFromJson(List<dynamic> articles) =>
      articles.map((a) => LArticle.fromJson(a!)).toList();
}
