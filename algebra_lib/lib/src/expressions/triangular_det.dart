import 'dart:math';

import 'package:algebra_lib/algebra_lib.dart';
import 'package:fraction/fraction.dart';

class TriangularDet implements Expression {
  final Expression matrix;

  TriangularDet({required this.matrix}) {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is! Matrix) {
      return TriangularDet(matrix: matrix.simplify());
    }

    Matrix m = matrix.simplify() as Matrix;

    if (m.rowsCount() != m.columnCount()) {
      throw DeterminantNotSquareException();
    }

    // If the matrix contains non-computed expressions, return simplified
    if (m != matrix) {
      return TriangularDet(matrix: m);
    }

    int rows = m.rowsCount();
    int columns = m.columnCount();
    int diagonal = min(rows, columns);

    Scalar zero = Scalar(value: Fraction(0));
    Scalar one = Scalar(value: Fraction(1));
    Scalar nOne = Scalar(value: Fraction(-1));

    for (var i = 0; i < diagonal; i++) {
      int? nonZero;
      // Find row with non-zero value
      for (var j = 0; j < (rows - i); j++) {
        if (m[j + i][i] != zero) {
          nonZero ??= j + i;
          // Prefer 1 over other non-zero values
          if (m[j + i][i] == one) {
            nonZero = j + i;
            break;
          }
        }
      }
      if (nonZero == null) continue;

      // Exchange rows if necessary
      if (nonZero != i) {
        return TriangularDet(
          matrix: ExchangeRows(
            matrix: MultiplyRowByN(matrix: m, n: nOne, row: i),
            row1: i,
            row2: nonZero,
          ),
        );
      }

      // Clear remaining rows
      for (var j = 0; j < (rows - i - 1); j++) {
        int row = i + 1 + j;
        if (m[row][i] == zero) continue;

        return TriangularDet(
          matrix: AddRowToRowNTimes(
            matrix: m,
            origin: i,
            target: row,
            n: Divide(
              numerator: Multiply(left: nOne, right: m[row][i]),
              denominator: m[i][i],
            ),
          ),
        );
      }
    }

    return m;
  }

  @override
  String toTeX() => 'triang|${matrix.toTeX()}|';
}
