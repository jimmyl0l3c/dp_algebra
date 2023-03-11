import 'package:algebra_lib/algebra_lib.dart';

class Inverse implements Expression {
  final Expression exp;

  Inverse({required this.exp}) {
    if (exp is Vector) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (exp is Vector) {
      throw UndefinedOperationException();
    }

    if (exp is! Matrix && exp is! Scalar) {
      return Inverse(exp: exp.simplify());
    }

    if (exp is Scalar) {
      if (exp == Scalar.zero()) {
        throw DivisionByZeroException();
      }

      return Scalar(value: (exp as Scalar).value.inverse());
    }

    // TODO: check if det == 0

    Matrix matrix = (exp as Matrix);
    List<List<Expression>> inverseMatrix = [];

    for (var r = 0; r < matrix.rowCount(); r++) {
      List<Expression> inverseRow = [];
      for (var c = 0; c < matrix.rowCount(); c++) {
        inverseRow.add(AlgSupplement(matrix: matrix, row: c, column: r));
      }

      inverseMatrix.add(inverseRow);
    }

    return Multiply(
      left: Inverse(exp: Determinant(det: matrix)),
      right: Matrix(rows: inverseMatrix),
    );
  }

  @override
  String toTeX() => '${exp.toTeX()}^{-1}';
}
