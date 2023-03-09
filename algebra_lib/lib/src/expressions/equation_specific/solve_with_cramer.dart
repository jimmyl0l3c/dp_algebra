import 'package:algebra_lib/algebra_lib.dart';

class SolveWithCramer implements Expression {
  final Expression matrix;
  final Expression vectorY;

  SolveWithCramer({required this.matrix, required this.vectorY}) {
    if (matrix is Scalar || matrix is Vector) {
      throw UndefinedOperationException();
    }
    if (vectorY is Scalar || vectorY is Matrix) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (matrix is Scalar || matrix is Vector) {
      throw UndefinedOperationException();
    }
    if (vectorY is Scalar || vectorY is Matrix) {
      throw UndefinedOperationException();
    }

    if (matrix is! Matrix) {
      return SolveWithCramer(matrix: matrix.simplify(), vectorY: vectorY);
    }
    if (vectorY is! Vector) {
      return SolveWithCramer(matrix: matrix, vectorY: vectorY.simplify());
    }

    List<Expression> solution = [];
    Matrix m = matrix as Matrix;
    Vector vY = vectorY as Vector;

    for (var i = 0; i < m.columnCount(); i++) {
      var matrixAi = m.rows.map((row) => List<Expression>.from(row)).toList();
      for (var j = 0; j < m.rowCount(); j++) {
        matrixAi[j][i] = vY[j];
      }

      // TODO: optimize - compute detA only once
      solution.add(Divide(
        numerator: Determinant(det: Matrix(rows: matrixAi)),
        denominator: Determinant(det: m),
      ));
    }

    return Vector(items: solution);
  }

  @override
  String toTeX() {
    StringBuffer buffer = StringBuffer();
    buffer.write(r'cramer \left( \begin{matrix} ');

    buffer.write(matrix.toTeX());

    buffer.write(r'\end{matrix} \middle\vert \, \begin{matrix} ');

    buffer.write(vectorY.toTeX());

    buffer.write(r'\end{matrix} \right)');
    return buffer.toString();
  }
}
