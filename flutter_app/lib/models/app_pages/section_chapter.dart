import 'package:dp_algebra/models/app_pages/section_page.dart';

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
