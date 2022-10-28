import 'dart:async';

import '../matrices/equation_solution.dart';
import '../matrices/matrix.dart';
import '../matrices/matrix_solution.dart';

class CalcDataController {
  static final List<MatrixSolution> _matrixSolutions = [];
  static final Matrix _equationMatrix = Matrix(columns: 3);
  static final List<EquationSolution> _equationSolutions = [];

  static final StreamController<List<MatrixSolution>>
      _matrixSolutionStreamController =
      StreamController<List<MatrixSolution>>();
  static final Stream<List<MatrixSolution>> matrixSolutionStream =
      _matrixSolutionStreamController.stream.asBroadcastStream();

  static final StreamController<List<EquationSolution>>
      _equationSolutionsStreamController =
      StreamController<List<EquationSolution>>();
  static final Stream<List<EquationSolution>> equationSolutionsStream =
      _equationSolutionsStreamController.stream.asBroadcastStream();

  static void addMatrixSolution(MatrixSolution solution) {
    _matrixSolutions.add(solution);
    _matrixSolutionStreamController.add(_matrixSolutions);
  }

  static void addEquationSolution(EquationSolution solution) {
    _equationSolutions.add(solution);
    _equationSolutionsStreamController.add(_equationSolutions);
  }

  static void dispose() {
    _matrixSolutionStreamController.close();
    _equationSolutionsStreamController.close();
  }

  static Matrix getEquationMatrix() => _equationMatrix;
}
