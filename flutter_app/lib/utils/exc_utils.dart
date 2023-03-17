import 'dart:math';

import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/models/exc_state/variable_value.dart';
import 'package:dp_algebra/models/input/matrix_model.dart';
import 'package:dp_algebra/models/input/vector_model.dart';
import 'package:fraction/fraction.dart';

class ExerciseUtils {
  static Random random = Random();

  static MatrixModel generateMatrix({int? rows, int? columns}) {
    rows ??= generateSize();
    columns ??= generateSize();

    MatrixModel m = MatrixModel(rows: rows, columns: columns);

    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < columns; j++) {
        m[i][j] = generateFraction();
      }
    }

    return m;
  }

  static MatrixModel generateSquareMatrix(int size) =>
      ExerciseUtils.generateMatrix(
        rows: size,
        columns: size,
      );

  static VectorModel generateVector({int? length}) {
    length ??= generateSize();

    VectorModel v = VectorModel(length: length);

    for (var i = 0; i < length; i++) {
      v[i] = generateFraction();
    }

    return v;
  }

  static Fraction generateFraction() {
    int num = random.nextInt(30) - 15;
    return num.toFraction();
  }

  static int generateSize({int max = 4, int min = 1}) =>
      random.nextInt(max - min + 1) + min;

  static List<VectorModel> generateBasis({
    int? vectorLength,
    int? basisLength,
  }) {
    // TODO: make sure the vectors are lin. independent
    List<VectorModel> vectors = [];
    vectorLength ??= generateSize(min: 2);
    basisLength ??= generateSize(min: 2, max: 3);

    for (var i = 0; i < basisLength; i++) {
      vectors.add(generateVector(length: vectorLength));
    }

    return vectors;
  }

  static Vector vectorFromSolutionMap(
      Map<int, SolutionVariable> inputSolution, int variableCount) {
    List<Expression> solutionVector = [];
    for (var i = 0; i < variableCount; i++) {
      if (inputSolution[i] != null) {
        solutionVector.add(inputSolution[i]!.toExpression(i));
      } else {
        solutionVector.add(Scalar(value: 0.toFraction()));
      }
    }

    return Vector(items: solutionVector);
  }
}
