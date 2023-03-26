import 'package:flutter/material.dart';

import '../../models/app_pages/section_chapter.dart';
import '../../widgets/layout/main_scaffold.dart';
import '../../widgets/layout/section_menu.dart';

class AlgMenuView extends StatelessWidget {
  final String sectionTitle;
  final String sectionPath;
  final List<SectionChapterModel> chapters;

  const AlgMenuView({
    Key? key,
    required this.sectionTitle,
    required this.sectionPath,
    required this.chapters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Section> sections = [];
    for (var i = 0; i < chapters.length; i++) {
      SectionChapterModel chapter = chapters[i];
      sections.add(Section(
        title: chapter.title,
        subtitle: chapter.subtitle,
        path: '/$sectionPath/$i',
      ));
    }

    return MainScaffold(
      isSectionRoot: true,
      title: sectionTitle,
      child: SectionMenu(
        sections: sections,
      ),
    );
  }
}
