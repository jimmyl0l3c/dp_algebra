import 'package:dp_algebra/models/app_pages/section_chapter.dart';
import 'package:dp_algebra/models/app_pages/section_page.dart';
import 'package:dp_algebra/pages/exercise/equation_exercises/equation_exc.dart';
import 'package:dp_algebra/pages/exercise/matrix_exercises/binary_matrix_exc.dart';
import 'package:dp_algebra/pages/exercise/matrix_exercises/determinant_exc.dart';
import 'package:dp_algebra/pages/exercise/matrix_exercises/inverse_exc.dart';
import 'package:dp_algebra/pages/exercise/vector_exercises/basis_exc.dart';
import 'package:dp_algebra/pages/exercise/vector_exercises/lin_independence_exc.dart';
import 'package:dp_algebra/pages/exercise/vector_exercises/transform_matrix_exc.dart';

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
      pages: [
        SectionPageModel(
          title: 'Lineární (ne)závislost vektorů',
          page: const LinIndependenceExc(),
        ),
        SectionPageModel(
          title: 'Nálezení báze',
          page: const BasisExc(),
        ),
        SectionPageModel(
          title: 'Transformace souřadnic',
          page: const TransformMatrixExc(),
        ),
      ],
    ),
    SectionChapterModel(
      title: 'Soustavy lineárních rovnic',
      pages: [
        SectionPageModel(
          title: 'Soustavy lineárních rovnic',
          page: const EquationExc(),
        ),
      ],
    ),
  ];
}
