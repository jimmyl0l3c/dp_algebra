import 'dart:async';

import 'package:dp_algebra/matrices/equation_matrix.dart';
import 'package:dp_algebra/matrices/equation_solution.dart';
import 'package:dp_algebra/matrices/matrix_solution.dart';
import 'package:dp_algebra/matrices/vector.dart';
import 'package:dp_algebra/matrices/vector_solution.dart';

class CalcDataController {
  static final List<MatrixSolution> _matrixSolutions = [];

  static final EquationMatrix _equationMatrix = EquationMatrix(columns: 3);
  static final List<EquationSolution> _equationSolutions = [];

  static final List<Vector> _vectors = [Vector(length: 1), Vector(length: 1)];

  static final List<VectorSolution> _vectorSolutions = [];

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

  static final StreamController<List<VectorSolution>>
      _vectorSolutionsStreamController =
      StreamController<List<VectorSolution>>();
  static final Stream<List<VectorSolution>> vectorSolutionStream =
      _vectorSolutionsStreamController.stream.asBroadcastStream();

  static void addMatrixSolution(MatrixSolution solution) {
    _matrixSolutions.add(solution);
    _matrixSolutionStreamController.add(_matrixSolutions);
  }

  static void addEquationSolution(EquationSolution solution) {
    _equationSolutions.add(solution);
    _equationSolutionsStreamController.add(_equationSolutions);
  }

  static void addVectorSolution(VectorSolution solution) {
    _vectorSolutions.add(solution);
    _vectorSolutionsStreamController.add(_vectorSolutions);
  }

  static void dispose() {
    // _matrixSolutionStreamController.close();
    // _equationSolutionsStreamController.close();
  }

  static EquationMatrix getEquationMatrix() => _equationMatrix;

  static List<Vector> getVectors() => _vectors;
}
