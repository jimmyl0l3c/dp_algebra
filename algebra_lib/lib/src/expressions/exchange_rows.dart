import 'package:algebra_lib/algebra_lib.dart';

class ExchangeRows implements Expression {
  final Matrix matrix;
  final int row1;
  final int row2;

  ExchangeRows({required this.matrix, required this.row1, required this.row2});

  @override
  Expression simplify() {
    // TODO: check that in constructor
    if (row1 >= matrix.rows() || row1 < 0) {
      throw IndexError.withLength(row1, matrix.rows());
    }

    if (row2 >= matrix.rows() || row2 < 0) {
      throw IndexError.withLength(row2, matrix.rows());
    }

    var simplifiedMatrix =
        matrix.items.map((row) => List<Expression>.from(row)).toList();
    List<Expression> tmp = simplifiedMatrix[row1];
    simplifiedMatrix[row1] = simplifiedMatrix[row2];
    simplifiedMatrix[row2] = tmp;

    return Matrix(items: simplifiedMatrix);
  }

  @override
  String toTeX() => matrix.toTeX();
}
