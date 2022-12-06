import 'package:dp_algebra/models/section_chapter.dart';
import 'package:dp_algebra/models/section_page.dart';
import 'package:dp_algebra/pages/calc/calc_equations.dart';
import 'package:dp_algebra/pages/calc/calc_matrices.dart';
import 'package:dp_algebra/pages/calc/calc_vector_independence.dart';

class CalcData {
  static List<SectionChapterModel> chapters = [
    SectionChapterModel(
      title: 'Operace s maticemi',
      subtitle:
          'Součet, rozdíl, součin, vlastnosti matic (hodnost, determinant)',
      pages: [SectionPageModel(title: '', page: CalcMatrices())],
    ),
    SectionChapterModel(
      title: 'Soustavy lineárních rovnic',
      pages: [SectionPageModel(title: '', page: CalcEquations())],
    ),
    SectionChapterModel(
      title: 'Vektorové prostory',
      subtitle:
          'Lineární (ne)závislost vektorů, nalezení báze, transformace souřadnic od báze k bázi, ...',
      pages: [
        SectionPageModel(
          title: 'Lineární (ne)závislost vektorů',
          page: CalcVectorIndependence(),
        ),
      ],
    ),
  ];
}
