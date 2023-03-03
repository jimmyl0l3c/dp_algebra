import 'package:algebra_lib/algebra_lib.dart';

class ExchangeRows implements Expression {
  final Expression matrix;
  final int row1;
  final int row2;

  ExchangeRows({
    required this.matrix,
    required this.row1,
    required this.row2,
  }) {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is Matrix) {
      Matrix m = matrix as Matrix;
      if (row1 < 0 || row1 >= m.rowsCount()) {
        throw IndexError.withLength(row1, m.rowsCount());
      }

      if (row2 < 0 || row2 >= m.rowsCount()) {
        throw IndexError.withLength(row2, m.rowsCount());
      }
    }
  }

  @override
  Expression simplify() {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is! Matrix) {
      return ExchangeRows(
        matrix: matrix.simplify(),
        row1: row1,
        row2: row2,
      );
    }

    var simplifiedMatrix = (matrix as Matrix)
        .rows
        .map((row) => List<Expression>.from(row))
        .toList();

    List<Expression> tmp = simplifiedMatrix[row1];
    simplifiedMatrix[row1] = simplifiedMatrix[row2];
    simplifiedMatrix[row2] = tmp;

    return Matrix(rows: simplifiedMatrix);
  }

  @override
  String toTeX() => '(Exchange $row1 with $row2 ${matrix.toTeX()})';
}
