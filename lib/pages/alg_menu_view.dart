import 'package:dp_algebra/models/section_chapter.dart';
import 'package:dp_algebra/widgets/main_scaffold.dart';
import 'package:dp_algebra/widgets/section_menu.dart';
import 'package:flutter/material.dart';

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
