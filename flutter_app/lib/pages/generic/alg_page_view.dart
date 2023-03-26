import 'package:flutter/material.dart';

import '../../models/app_pages/section_chapter.dart';
import '../../models/app_pages/section_page.dart';
import '../../widgets/layout/main_scaffold.dart';

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
