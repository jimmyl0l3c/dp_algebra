import 'dart:math';

import 'package:dp_algebra/logic/matrix/matrix_model.dart';
import 'package:dp_algebra/logic/vector/vector_model.dart';
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
}
