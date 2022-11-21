import 'package:dp_algebra/models/section_chapter.dart';
import 'package:dp_algebra/models/section_page.dart';
import 'package:dp_algebra/pages/exercise/matrix_exercises/binary_matrix_exc.dart';
import 'package:dp_algebra/pages/exercise/matrix_exercises/determinant_exc.dart';
import 'package:dp_algebra/pages/exercise/matrix_exercises/inverse_exc.dart';

class ExerciseData {
  static List<SectionChapterModel> chapters = [
    SectionChapterModel(
      title: 'Matice',
      subtitle: 'Součet, rozdíl, součin, determinant, inverzní matice',
      pages: [
        SectionPageModel(
          title: 'Sčítání, odčítání, násobení',
          page: const BinaryMatrixExc(),
        ),
        SectionPageModel(
          title: 'Determinant',
          page: const DeterminantExc(),
        ),
        SectionPageModel(
          title: 'Inverzní matice',
          page: const InverseMatrixExc(),
        ),
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
