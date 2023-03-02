import 'package:algebra_lib/algebra_lib.dart';

class AddRowToRowNTimes implements Expression {
  final Matrix matrix;
  final int origin;
  final int target;
  final Expression n;

  AddRowToRowNTimes({
    required this.matrix,
    required this.origin,
    required this.target,
    required this.n,
  }) {
    if (origin < 0 || origin >= matrix.rowsCount()) {
      throw IndexError.withLength(origin, matrix.rowsCount());
    }

    if (target < 0 || target >= matrix.rowsCount()) {
      throw IndexError.withLength(target, matrix.rowsCount());
    }

    if (n is Matrix || n is Vector) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (n is Matrix || n is Vector) {
      throw UndefinedOperationException();
    }

    if (n is! Scalar) {
      return AddRowToRowNTimes(
        matrix: matrix,
        origin: origin,
        target: target,
        n: n.simplify(),
      );
    }

    var simplifiedMatrix =
        matrix.rows.map((row) => List<Expression>.from(row)).toList();

    List<Expression> simplifiedRow = [];
    for (var i = 0; i < matrix.columnCount(); i++) {
      simplifiedRow.add(Addition(
        left: matrix[target][i],
        right: Multiply(
          left: n,
          right: matrix[origin][i],
        ),
      ));
    }

    simplifiedMatrix[target] = simplifiedRow;

    return Matrix(rows: simplifiedMatrix);
  }

  @override
  String toTeX() {
    // TODO: implement toTeX
    throw UnimplementedError();
  }
}
