import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../models/app_pages/section_chapter.dart';
import '../../widgets/layout/main_scaffold.dart';
import '../../widgets/layout/section_menu.dart';

class AlgMenuView extends StatelessWidget {
  final String sectionTitle;
  final String sectionPath;
  final List<SectionChapterModel> chapters;

  const AlgMenuView({
    super.key,
    required this.sectionTitle,
    required this.sectionPath,
    required this.chapters,
  });

  @override
  Widget build(BuildContext context) => MainScaffold(
        isSectionRoot: true,
        title: sectionTitle,
        child: SectionMenu(
          sections: chapters
              .mapIndexed((i, chapter) => Section(
                    title: chapter.title,
                    subtitle: chapter.subtitle,
                    path: '/$sectionPath/$i',
                  ))
              .toList(),
        ),
      );
}
