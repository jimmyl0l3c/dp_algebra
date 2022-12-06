import 'package:dp_algebra/matrices/vector_solution.dart';
import 'package:flutter/widgets.dart';

class CalcVectorSolutionsModel extends ChangeNotifier {
  final solutions = ValueNotifier<List<VectorSolution>>([]);

  void addSolution(VectorSolution solution) {
    solutions.value.add(solution);
    solutions.notifyListeners();
  }

  VectorSolution removeSolution(int index) {
    VectorSolution removed = solutions.value.removeAt(index);
    solutions.notifyListeners();
    return removed;
  }

  void clear() {
    solutions.value.clear();
    solutions.notifyListeners();
  }
}
