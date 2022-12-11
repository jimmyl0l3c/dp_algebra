import 'dart:math';

import 'package:dp_algebra/logic/matrix/matrix.dart';
import 'package:fraction/fraction.dart';

class ExerciseUtils {
  static Random random = Random();

  static Matrix generateMatrix({int? rows, int? columns}) {
    rows ??= generateSize();
    columns ??= generateSize();

    Matrix m = Matrix(rows: rows, columns: columns);

    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < columns; j++) {
        m[i][j] = generateFraction();
      }
    }

    return m;
  }

  static Fraction generateFraction() {
    int num = random.nextInt(50) - 25;
    return num.toFraction();
  }

  static int generateSize() => random.nextInt(4) + 1;
}
