import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../models/app_pages/section_chapter.dart';
import '../../widgets/layout/main_scaffold.dart';
import '../../widgets/layout/section_menu.dart';

class AlgChapterView extends StatelessWidget {
  final String sectionTitle;
  final String sectionPath;
  final SectionChapterModel chapter;
  final int chapterId;

  const AlgChapterView({
    super.key,
    required this.sectionTitle,
    required this.sectionPath,
    required this.chapter,
    required this.chapterId,
  });

  @override
  Widget build(BuildContext context) {
    if (chapter.pages.length == 1) {
      return MainScaffold(
        title: '$sectionTitle \u2014 ${chapter.title}',
        child: chapter.pages.first.page,
      );
    }

    return MainScaffold(
      title: '$sectionTitle \u2014 ${chapter.title}',
      child: SectionMenu(
        sections: chapter.pages
            .mapIndexed((i, page) => Section(
                  title: page.title,
                  subtitle: page.subtitle,
                  path: '/$sectionPath/$chapterId/$i',
                ))
            .toList(),
      ),
    );
  }
}
