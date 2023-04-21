import '../models/app_pages/section_chapter.dart';
import '../models/app_pages/section_page.dart';
import '../pages/exercise/equation_exercises/equation_exc.dart';
import '../pages/exercise/matrix_exercises/binary_matrix_exc.dart';
import '../pages/exercise/matrix_exercises/determinant_exc.dart';
import '../pages/exercise/matrix_exercises/inverse_exc.dart';
import '../pages/exercise/vector_exercises/basis_exc.dart';
import '../pages/exercise/vector_exercises/lin_independence_exc.dart';
import '../pages/exercise/vector_exercises/transform_matrix_exc.dart';

/// Data for Exercise section
final List<SectionChapterModel> exerciseChapters = [
  const SectionChapterModel(
    title: 'Matice',
    subtitle: 'Součet, rozdíl, součin, determinant, inverzní matice',
    pages: [
      SectionPageModel(
        title: 'Sčítání, odčítání, násobení',
        page: BinaryMatrixExc(),
      ),
      SectionPageModel(
        title: 'Determinant',
        page: DeterminantExc(),
      ),
      SectionPageModel(
        title: 'Inverzní matice',
        page: InverseMatrixExc(),
      ),
    ],
  ),
  const SectionChapterModel(
    title: 'Vektorové prostory',
    subtitle:
        'Lineární (ne)závislost vektorů, nalezení báze, transformace souřadnic od báze k bázi, ...',
    pages: [
      SectionPageModel(
        title: 'Lineární (ne)závislost vektorů',
        page: LinIndependenceExc(),
      ),
      SectionPageModel(
        title: 'Nalezení báze',
        page: BasisExc(),
      ),
      SectionPageModel(
        title: 'Transformace souřadnic',
        page: TransformMatrixExc(),
      ),
    ],
  ),
  const SectionChapterModel(
    title: 'Soustavy lineárních rovnic',
    pages: [
      SectionPageModel(
        title: 'Soustavy lineárních rovnic',
        page: EquationExc(),
      ),
    ],
  ),
];
