import '../models/app_pages/section_chapter.dart';
import '../models/app_pages/section_page.dart';
import '../pages/calc/calc_equations.dart';
import '../pages/calc/calc_matrices.dart';
import '../pages/calc/calc_vector_spaces.dart';

/// Data for Calculator section
final List<SectionChapterModel> calcChapters = [
  SectionChapterModel(
    title: 'Operace s maticemi',
    subtitle: 'Součet, rozdíl, součin, vlastnosti matic (hodnost, determinant)',
    pages: [SectionPageModel(title: '', page: CalcMatrices())],
  ),
  SectionChapterModel(
    title: 'Vektorové prostory',
    subtitle:
        'Lineární (ne)závislost vektorů, nalezení báze, transformace souřadnic od báze k bázi, ...',
    pages: [
      SectionPageModel(title: '', page: CalcVectorSpaces()),
    ],
  ),
  SectionChapterModel(
    title: 'Soustavy lineárních rovnic',
    pages: [SectionPageModel(title: '', page: CalcEquations())],
  ),
];
