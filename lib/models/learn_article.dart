import 'learn_page.dart';

class LArticle {
  final int id;
  final String title;
  final String? description;
  List<LPage> pages;
  final int chapterId;

  LArticle(this.id, this.title, this.pages, this.chapterId, {this.description});
}
