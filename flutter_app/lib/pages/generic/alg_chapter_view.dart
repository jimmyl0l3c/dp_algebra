import 'package:flutter/material.dart';

import '../../models/app_pages/section_chapter.dart';
import '../../models/app_pages/section_page.dart';
import '../../widgets/layout/main_scaffold.dart';
import '../../widgets/layout/section_menu.dart';

class AlgChapterView extends StatelessWidget {
  final String sectionTitle;
  final String sectionPath;
  final SectionChapterModel chapter;
  final int chapterId;

  const AlgChapterView({
    Key? key,
    required this.sectionTitle,
    required this.sectionPath,
    required this.chapter,
    required this.chapterId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (chapter.pages.length == 1) {
      return MainScaffold(
        title: '$sectionTitle \u2014 ${chapter.title}',
        child: chapter.pages.first.page,
      );
    }

    List<Section> sections = [];
    for (var i = 0; i < chapter.pages.length; i++) {
      SectionPageModel page = chapter.pages[i];
      sections.add(Section(
        title: page.title,
        subtitle: page.subtitle,
        path: '/$sectionPath/$chapterId/$i',
      ));
    }

    return MainScaffold(
      title: '$sectionTitle \u2014 ${chapter.title}',
      child: SectionMenu(
        sections: sections,
      ),
    );
  }
}
