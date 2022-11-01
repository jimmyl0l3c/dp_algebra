import 'package:fraction/fraction.dart';

import 'extensions.dart';
import 'equation_exceptions.dart';
import 'matrix.dart';

class EquationMatrix extends Matrix {
  EquationMatrix({int columns = 1, int rows = 1, int defaultValue = 0})
      : super(columns: columns, rows: rows, defaultValue: defaultValue);

  EquationMatrix.from(EquationMatrix m)
      : super.from(m);

  bool isSolvableByCramer() {
    Matrix A = Matrix.from(this)..removeColumn(getColumns() - 1);
    return A.isSquare() && A.determinant() != 0.toFraction();
  }

  bool isSolvable() {
    Matrix A = Matrix.from(this)..removeColumn(getColumns() - 1);
    return A.rank() == rank();
  }

  Matrix solveByCramer() {
    Matrix A = Matrix.from(this);
    List<Fraction> yT = A.removeColumn(getColumns() - 1);
    Fraction detA = A.determinant();
    Matrix solution = Matrix(columns: A.getColumns());

    if (detA == 0.toFraction()) throw EqNotSolvableByCramerException();

    for (var i = 0; i < A.getColumns(); i++) {
      Matrix Ai = Matrix.from(A);

      for (var j = 0; j < A.getRows(); j++) {
        Ai[j][i] = yT[j];
      }

      solution[0][i] = Ai.determinant() / detA;
    }

    return solution;
  }

  Matrix solveByGauss() {
    if (!isSolvable()) {
      throw EquationsNotSolvableException();
    }

    Matrix A = triangular();
    Matrix solution = Matrix(columns: A.getColumns());

    A.reduce();
    // TODO: implement

    return A;
  }

  Matrix solveByInverse() {
    Matrix A = Matrix.from(this);
    List<Fraction> yValues = A.removeColumn(getColumns() - 1);

    Matrix yT = Matrix(columns: 1, rows: yValues.length);
    for (var i = 0; i < yValues.length; i++) {
      yT[i][0] = yValues[i];
    }

    Matrix invA = A.inverse();

    return (invA * yT).transposed();
  }

  @override
  String toTeX({bool isDeterminant = false}) {
    StringBuffer buffer = StringBuffer();
    int rows = getRows();
    int cols = getColumns();

    buffer.write(r'\left( \begin{matrix} ');

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols - 1; c++) {
        buffer.write(this[r][c].reduce().toTeX());

        if (c != (cols - 1)) buffer.write(' & ');
      }
      if (r != (rows - 1)) buffer.write(r' \\ ');
    }

    buffer.write(r'\end{matrix} \middle\vert \, \begin{matrix} ');

    for (var r = 0; r < rows; r++) {
      buffer.write(this[r][cols - 1].reduce().toTeX());

      if (r != (rows - 1)) buffer.write(r' \\ ');
    }

    buffer.write(r'\end{matrix} \right)');

    return buffer.toString();
  }
}
