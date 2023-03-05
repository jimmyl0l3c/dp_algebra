import 'package:algebra_lib/algebra_lib.dart';
import 'package:algebra_lib/src/utils/tex_utils.dart';

class MultiplyRowByN implements Expression {
  final Expression matrix;
  final Expression n;
  final int row;

  MultiplyRowByN({required this.matrix, required this.n, required this.row}) {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is Matrix) {
      Matrix m = matrix as Matrix;
      if (row < 0 || row >= m.rowCount()) {
        throw IndexError.withLength(row, m.rowCount());
      }
    }

    if (n is Matrix || n is Vector) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    // if (n is Matrix || n is Vector) {
    //   throw UndefinedOperationException();
    // }
    //
    // if (n is! Scalar) {
    //   return MultiplyRowByN(
    //     matrix: matrix,
    //     n: n.simplify(),
    //     row: row,
    //   );
    // }

    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is! Matrix) {
      return MultiplyRowByN(
        matrix: matrix.simplify(),
        n: n,
        row: row,
      );
    }

    Matrix m = matrix as Matrix;

    if (row < 0 || row >= m.rowCount()) {
      throw IndexError.withLength(row, m.rowCount());
    }

    var simplifiedMatrix =
        m.rows.map((row) => List<Expression>.from(row)).toList();

    List<Expression> simplifiedRow = [];
    for (var i = 0; i < m.columnCount(); i++) {
      simplifiedRow.add(Multiply(left: n, right: m[row][i]));
    }

    simplifiedMatrix[row] = simplifiedRow;

    return Matrix(rows: simplifiedMatrix);
  }

  @override
  String toTeX() {
    return TexUtils.rowTransformToTeX(
      matrix,
      'r_{$row} \\cdot ${n.toTeX()}',
    );
  }
}
