import 'package:dp_algebra/models/app_pages/section_chapter.dart';
import 'package:dp_algebra/models/app_pages/section_page.dart';
import 'package:dp_algebra/widgets/layout/main_scaffold.dart';
import 'package:flutter/material.dart';

class AlgPageView extends StatelessWidget {
  final String sectionTitle;
  final SectionChapterModel chapter;
  final SectionPageModel page;

  const AlgPageView({
    Key? key,
    required this.sectionTitle,
    required this.chapter,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: '$sectionTitle - ${chapter.title} - ${page.title}',
      child: page.page,
    );
  }
}
