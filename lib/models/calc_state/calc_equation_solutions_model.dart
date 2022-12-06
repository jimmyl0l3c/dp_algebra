import 'package:dp_algebra/matrices/equation_solution.dart';
import 'package:flutter/widgets.dart';

class CalcEquationSolutionsModel extends ChangeNotifier {
  final solutions = ValueNotifier<List<EquationSolution>>([]);

  void addSolution(EquationSolution solution) {
    solutions.value.add(solution);
    solutions.notifyListeners();
  }

  EquationSolution removeSolution(int index) {
    EquationSolution removed = solutions.value.removeAt(index);
    solutions.notifyListeners();
    return removed;
  }

  void clear() {
    solutions.value.clear();
    solutions.notifyListeners();
  }
}
