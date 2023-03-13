import 'package:dp_algebra/models/app_pages/section_chapter.dart';
import 'package:dp_algebra/models/app_pages/section_page.dart';
import 'package:dp_algebra/widgets/layout/main_scaffold.dart';
import 'package:dp_algebra/widgets/layout/section_menu.dart';
import 'package:flutter/material.dart';

class AlgChapterView extends StatelessWidget {
  final String sectionTitle;
  final SectionChapterModel chapter;
  final int chapterId;

  const AlgChapterView({
    Key? key,
    required this.sectionTitle,
    required this.chapter,
    required this.chapterId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (chapter.pages.length == 1) {
      return MainScaffold(
        title: '$sectionTitle - ${chapter.title}',
        child: chapter.pages.first.page,
      );
    }

    List<Section> sections = [];
    for (var i = 0; i < chapter.pages.length; i++) {
      SectionPageModel page = chapter.pages[i];
      sections.add(Section(
        title: page.title,
        subtitle: page.subtitle,
        path: '/exercise/$chapterId/$i',
      ));
    }

    return MainScaffold(
      title: '$sectionTitle - ${chapter.title}',
      child: SectionMenu(
        sections: sections,
      ),
    );
  }
}
