import 'package:dp_algebra/models/exercise_chapter.dart';
import 'package:dp_algebra/models/exercise_page.dart';
import 'package:flutter/material.dart';

class ExerciseData {
  static List<ExerciseChapterModel> chapters = [
    ExerciseChapterModel(
      title: 'Matice',
      exercisePages: [
        ExercisePageModel(
            title: 'Test', page: const Center(child: Text('Test page')))
      ],
    ),
    ExerciseChapterModel(
      title: 'Vektorové prostory',
      exercisePages: [],
    ),
    ExerciseChapterModel(
      title: 'Soustavy lineárních rovnic',
      exercisePages: [],
    ),
  ];
}
