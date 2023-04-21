import 'section_page.dart';

class SectionChapterModel {
  final String title;
  final String? subtitle;
  final List<SectionPageModel> pages;

  const SectionChapterModel({
    required this.title,
    this.subtitle,
    required this.pages,
  });
}
