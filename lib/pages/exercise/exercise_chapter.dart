import 'package:dp_algebra/data/exercise_data.dart';
import 'package:dp_algebra/models/exercise_chapter.dart';
import 'package:dp_algebra/models/exercise_page.dart';
import 'package:dp_algebra/widgets/main_scaffold.dart';
import 'package:dp_algebra/widgets/section_menu.dart';
import 'package:flutter/material.dart';

class ExerciseChapter extends StatelessWidget {
  final String chapterId;

  const ExerciseChapter({Key? key, required this.chapterId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? chapterIndex = int.tryParse(chapterId);
    if (chapterIndex != null && chapterIndex < ExerciseData.chapters.length) {
      ExerciseChapterModel chapter = ExerciseData.chapters[chapterIndex];

      List<Section> sections = [];
      for (var i = 0; i < chapter.exercisePages.length; i++) {
        ExercisePageModel page = chapter.exercisePages[i];
        sections.add(Section(
          title: page.title,
          subtitle: page.subtitle,
          path: '/exercise/$chapterId/$i',
        ));
      }

      return MainScaffold(
        title: 'Procvičování - ${chapter.title}',
        child: SectionMenu(
          sections: sections,
        ),
      );
    }

    return const MainScaffold(
      title: 'Procvičování - Nenalezeno',
      child: Center(
        child: Text('Kapitola nenalezena'),
      ),
    );
  }
}
