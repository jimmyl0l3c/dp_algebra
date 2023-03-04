import 'package:algebra_lib/algebra_lib.dart';

class AddRowToRowNTimes implements Expression {
  final Expression matrix;
  final int origin;
  final int target;
  final Expression n;

  AddRowToRowNTimes({
    required this.matrix,
    required this.origin,
    required this.target,
    required this.n,
  }) {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is Matrix) {
      Matrix m = matrix as Matrix;
      if (origin < 0 || origin >= m.rowCount()) {
        throw IndexError.withLength(origin, m.rowCount());
      }

      if (target < 0 || target >= m.rowCount()) {
        throw IndexError.withLength(target, m.rowCount());
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
    //   return AddRowToRowNTimes(
    //     matrix: matrix,
    //     origin: origin,
    //     target: target,
    //     n: n.simplify(),
    //   );
    // }

    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is! Matrix) {
      return AddRowToRowNTimes(
        matrix: matrix.simplify(),
        origin: origin,
        target: target,
        n: n,
      );
    }

    Matrix m = matrix as Matrix;

    if (origin < 0 || origin >= m.rowCount()) {
      throw IndexError.withLength(origin, m.rowCount());
    }

    if (target < 0 || target >= m.rowCount()) {
      throw IndexError.withLength(target, m.rowCount());
    }

    var simplifiedMatrix =
        m.rows.map((row) => List<Expression>.from(row)).toList();

    List<Expression> simplifiedRow = [];
    for (var i = 0; i < m.columnCount(); i++) {
      simplifiedRow.add(Addition(
        left: m[target][i],
        right: Multiply(
          left: n,
          right: m[origin][i],
        ),
      ));
    }

    simplifiedMatrix[target] = simplifiedRow;

    return Matrix(rows: simplifiedMatrix);
  }

  @override
  String toTeX() {
    // TODO: implement toTeX
    return '(Add $origin to $target, ${n.toTeX()} times, ${matrix.toTeX()})';
  }
}
