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

    Matrix matrix = (exp as Matrix);
    List<Vector> inverseMatrix = [];

    for (var r = 0; r < matrix.rowCount; r++) {
      List<Expression> inverseRow = [];
      for (var c = 0; c < matrix.rowCount; c++) {
        inverseRow.add(AlgSupplement(matrix: matrix, row: c, column: r));
      }

      inverseMatrix.add(Vector(items: inverseRow));
    }

    return Multiply(
      left: Inverse(exp: Determinant(det: matrix)),
      right: Matrix(
        rows: inverseMatrix,
        rowCount: matrix.rowCount,
        columnCount: matrix.columnCount,
      ),
    );
  }

  @override
  String toTeX({Set<TexFlags>? flags}) => '${exp.toTeX()}^{-1}';
}
