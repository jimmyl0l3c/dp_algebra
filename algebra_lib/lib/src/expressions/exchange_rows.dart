import 'package:algebra_lib/algebra_lib.dart';

class ExchangeRows implements Expression {
  final Matrix matrix;
  final int row1;
  final int row2;

  ExchangeRows({
    required this.matrix,
    required this.row1,
    required this.row2,
  }) {
    if (row1 < 0 || row1 >= matrix.rowsCount()) {
      throw IndexError.withLength(row1, matrix.rowsCount());
    }

    if (row2 < 0 || row2 >= matrix.rowsCount()) {
      throw IndexError.withLength(row2, matrix.rowsCount());
    }
  }

  @override
  Expression simplify() {
    var simplifiedMatrix =
        matrix.rows.map((row) => List<Expression>.from(row)).toList();
    List<Expression> tmp = simplifiedMatrix[row1];
    simplifiedMatrix[row1] = simplifiedMatrix[row2];
    simplifiedMatrix[row2] = tmp;

    return Matrix(rows: simplifiedMatrix);
  }

  @override
  String toTeX() => matrix.toTeX();
}
