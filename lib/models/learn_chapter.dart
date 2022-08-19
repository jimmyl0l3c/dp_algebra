import 'learn_article.dart';

class LChapter {
  final int id;
  final String title;
  final String? description;
  List<LArticle> articles;

  LChapter(this.id, this.title, this.articles, {this.description});
}
