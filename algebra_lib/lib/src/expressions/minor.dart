import 'package:algebra_lib/algebra_lib.dart';

class Minor implements Expression {
  final Expression matrix;
  final int row;
  final int column;

  Minor({required this.matrix, required this.row, required this.column}) {
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
      return Minor(matrix: matrix.simplify(), row: row, column: column);
    }

    Matrix m = matrix as Matrix;
    if (m.rowsCount() != m.columnCount()) {
      throw DeterminantNotSquareException();
    }

    List<List<Expression>> minorRows = [];
    int n = m.rowsCount() - 1;

    //  Skip row and column
    for (var r = 0; r < n; r++) {
      if (r == row) continue;
      List<Expression> minorRow = [];
      for (var c = 0; c < n; c++) {
        if (c == column) continue;
        minorRow.add(m[r][c]);
      }
      minorRows.add(minorRow);
    }

    return Determinant(det: Matrix(rows: minorRows));
  }

  // TODO: implement toTeX
  @override
  String toTeX() => 'minor(r: $row, c: $column, ${matrix.toTeX()})';
}