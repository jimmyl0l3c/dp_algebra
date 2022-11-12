import 'package:dp_algebra/data/exercise_data.dart';
import 'package:dp_algebra/models/exercise_chapter.dart';
import 'package:dp_algebra/models/exercise_page.dart';
import 'package:dp_algebra/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';

class ExercisePage extends StatelessWidget {
  final String chapterId;
  final String pageId;

  const ExercisePage({
    Key? key,
    required this.chapterId,
    required this.pageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? chapterIndex = int.tryParse(chapterId);
    int? pageIndex = int.tryParse(pageId);
    if (chapterIndex == null ||
        pageIndex == null ||
        chapterIndex >= ExerciseData.chapters.length ||
        pageIndex >= ExerciseData.chapters[chapterIndex].exercisePages.length) {
      return const MainScaffold(
        title: 'Procvičování - Chyba',
        child: Center(
          child: Text('Stránka nenalezena'),
        ),
      );
    }

    ExerciseChapterModel chapter = ExerciseData.chapters[chapterIndex];
    ExercisePageModel page = chapter.exercisePages[pageIndex];

    return MainScaffold(
      title: 'Procvičování - ${chapter.title} - ${page.title}',
      child: page.page,
    );
  }
}
