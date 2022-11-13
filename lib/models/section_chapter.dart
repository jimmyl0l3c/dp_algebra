import 'package:dp_algebra/models/section_page.dart';

class SectionChapterModel {
  String title;
  String? subtitle;
  List<SectionPageModel> pages;

  SectionChapterModel({
    required this.title,
    this.subtitle,
    required this.pages,
  });
}
