import 'package:dp_algebra/matrices/equation_exceptions.dart';
import 'package:dp_algebra/matrices/equation_solution.dart';
import 'package:dp_algebra/matrices/extensions.dart';
import 'package:dp_algebra/matrices/matrix.dart';
import 'package:dp_algebra/matrices/vector.dart';
import 'package:fraction/fraction.dart';

class EquationMatrix extends Matrix {
  EquationMatrix({int columns = 1, int rows = 1, int defaultValue = 0})
      : super(columns: columns, rows: rows, defaultValue: defaultValue);

  EquationMatrix.from(EquationMatrix m) : super.from(m);

  EquationMatrix.fromVectors(List<Vector> vectors, {bool vertical = false})
      : super.fromVectors(vectors, vertical: vertical);

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

  GeneralSolution solveByGauss() {
    if (!isSolvable()) {
      throw EquationsNotSolvableException();
    }

    Matrix A = triangular()..reduce();

    Fraction zero = Fraction(0);
    GeneralSolution solution = GeneralSolution(A.getColumns() - 1);
    for (var r = 0; r < A.getRows(); r++) {
      for (var c = 0; c < A.getColumns() - 1; c++) {
        if (A[r][c] != zero) {
          for (var i = c + 1; i < A.getColumns(); i++) {
            if (i == A.getColumns() - 1) {
              solution.updateNumSolution(c, A[r][i]);
            } else {
              solution.updateSolution(c, i, A[r][i].negate());
            }
          }
          break;
        }
      }
    }

    return solution;
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
