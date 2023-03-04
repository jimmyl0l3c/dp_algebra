import 'package:dp_algebra/models/calc_result.dart';
import 'package:flutter/widgets.dart';

class CalcMatrixSolutionsModel2 extends ChangeNotifier {
  final solutions = ValueNotifier<List<CalcResult>>([]);

  void addSolution(CalcResult solution) {
    solutions.value.add(solution);
    solutions.notifyListeners();
  }

  CalcResult removeSolution(int index) {
    CalcResult removed = solutions.value.removeAt(index);
    solutions.notifyListeners();
    return removed;
  }

  void clear() {
    solutions.value.clear();
    solutions.notifyListeners();
  }
}
