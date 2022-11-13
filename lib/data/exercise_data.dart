import 'package:dp_algebra/models/section_chapter.dart';
import 'package:dp_algebra/models/section_page.dart';
import 'package:flutter/material.dart';

class ExerciseData {
  static List<SectionChapterModel> chapters = [
    SectionChapterModel(
      title: 'Matice',
      subtitle: 'Součet, rozdíl, součin, determinant, inverzní matice',
      pages: [
        SectionPageModel(
            title: 'Test', page: const Center(child: Text('Test page')))
      ],
    ),
    SectionChapterModel(
      title: 'Vektorové prostory',
      subtitle:
          'Lineární (ne)závislost vektorů, nalezení báze, transformace souřadnic od báze k bázi, ...',
      pages: [],
    ),
    SectionChapterModel(
      title: 'Soustavy lineárních rovnic',
      pages: [],
    ),
  ];
}
