import 'package:dp_algebra/models/calc/calc_category.dart';
import 'package:dp_algebra/models/calc/calc_result.dart';
import 'package:flutter/widgets.dart';

class CalcSolutionsModel extends ChangeNotifier {
  final Map<CalcCategory, List<CalcResult>> solutions = {};

  late final ValueNotifier<List<CalcResult>> matrixSolutions;
  late final ValueNotifier<List<CalcResult>> equationSolutions;
  late final ValueNotifier<List<CalcResult>> vectorSolutions;

  CalcSolutionsModel() {
    solutions.addAll({
      CalcCategory.matrixOperation: [],
      CalcCategory.vectorSpace: [],
      CalcCategory.equation: [],
    });

    matrixSolutions = ValueNotifier<List<CalcResult>>(
      solutions[CalcCategory.matrixOperation]!,
    );

    equationSolutions = ValueNotifier<List<CalcResult>>(
      solutions[CalcCategory.equation]!,
    );

    vectorSolutions = ValueNotifier<List<CalcResult>>(
      solutions[CalcCategory.vectorSpace]!,
    );
  }

  void addSolution(CalcResult solution, CalcCategory category) {
    solutions[category]?.add(solution);
    _notifyListeners(category);
  }

  CalcResult? removeSolution(CalcCategory category, int index) {
    CalcResult? removed = solutions[category]?.removeAt(index);
    _notifyListeners(category);
    return removed;
  }

  void clear(CalcCategory category) {
    solutions[category]?.clear();
    _notifyListeners(category);
  }

  void _notifyListeners(CalcCategory category) {
    switch (category) {
      case CalcCategory.matrixOperation:
        matrixSolutions.notifyListeners();
        break;
      case CalcCategory.equation:
        equationSolutions.notifyListeners();
        break;
      case CalcCategory.vectorSpace:
        vectorSolutions.notifyListeners();
        break;
    }
  }
}
