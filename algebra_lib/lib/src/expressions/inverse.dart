import 'package:algebra_lib/algebra_lib.dart';
import 'package:fraction/fraction.dart';

class Inverse implements Expression {
  final Expression exp;

  Inverse({required this.exp}) {
    if (exp is Vector || exp is Scalar) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (exp is Vector || exp is Scalar) {
      throw UndefinedOperationException();
    }

    if (exp is! Matrix) {
      return Inverse(exp: exp.simplify());
    }

    // TODO: check if det == 0

    Matrix matrix = (exp as Matrix);
    List<List<Expression>> inverseMatrix = [];

    for (var r = 0; r < matrix.rowsCount(); r++) {
      List<Expression> inverseRow = [];
      for (var c = 0; c < matrix.rowsCount(); c++) {
        inverseRow.add(AlgSupplement(matrix: matrix, row: c, column: r));
      }

      inverseMatrix.add(inverseRow);
    }

    return Multiply(
      left: Divide(
        // TODO: or implement inverse for Scalar?
        numerator: Scalar(value: Fraction(1)),
        denominator: Determinant(det: matrix),
      ),
      right: Matrix(rows: inverseMatrix),
    );
  }

  @override
  String toTeX() => '${exp.toTeX()}^{-1}';
}
