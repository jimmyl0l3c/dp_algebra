import 'dart:math';

import 'package:algebra_lib/algebra_lib.dart';
import 'package:fraction/fraction.dart';

class AlgSupplement implements Expression {
  final Expression matrix;
  final int row;
  final int column;

  AlgSupplement({
    required this.matrix,
    required this.row,
    required this.column,
  }) {
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
      return AlgSupplement(
        matrix: matrix.simplify(),
        row: row,
        column: column,
      );
    }

    Matrix m = matrix as Matrix;
    if (m.rowCount() != m.columnCount()) {
      throw DeterminantNotSquareException();
    }

    return Multiply(
      // TODO: make the computation of power of -1 out of expressions?
      left: Scalar(value: pow(-1, row + column + 2).toFraction()),
      right: Minor(matrix: matrix, row: row, column: column),
    );
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      '\\mathcal{A}_{$row,$column}${matrix.toTeX()}';
}
