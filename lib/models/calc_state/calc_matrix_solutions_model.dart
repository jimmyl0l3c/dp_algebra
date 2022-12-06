import 'package:dp_algebra/matrices/matrix_solution.dart';
import 'package:flutter/widgets.dart';

class CalcMatrixSolutionsModel extends ChangeNotifier {
  final solutions = ValueNotifier<List<MatrixSolution>>([]);

  void addSolution(MatrixSolution solution) {
    solutions.value.add(solution);
    solutions.notifyListeners();
  }

  MatrixSolution removeSolution(int index) {
    MatrixSolution removed = solutions.value.removeAt(index);
    solutions.notifyListeners();
    return removed;
  }

  void clear() {
    solutions.value.clear();
    solutions.notifyListeners();
  }
}
