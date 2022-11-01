import 'package:fraction/fraction.dart';

import 'extensions.dart';
import 'equation_exceptions.dart';
import 'matrix.dart';

class EquationMatrix extends Matrix {
  EquationMatrix({int columns = 1, int rows = 1, int defaultValue = 0})
      : super(columns: columns, rows: rows, defaultValue: defaultValue);

  EquationMatrix.from(EquationMatrix m) : super.from(m);

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

class GeneralSolution {
  final Map<int, Map<int, Fraction>> _solution = {};
  final Map<int, Fraction> _numSolution = {};

  GeneralSolution(int variableCount) {
    for (var i = 0; i < variableCount; i++) {
      _solution[i] = {i: 1.toFraction()}; // all variables are free by default
      _numSolution[i] = 0.toFraction();
    }
  }

  void updateSolution(variableNum, key, value) {
    if (!_solution.containsKey(variableNum)) return;

    _solution[variableNum]![key] = value;
    _solution[variableNum]!.remove(variableNum); // remove, not a free variable
  }

  void updateNumSolution(variableNum, value) {
    if (!_numSolution.containsKey(variableNum)) return;

    _numSolution[variableNum] = value;
    _solution[variableNum]!.remove(variableNum); // remove, not a free variable
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer('x = (');
    Fraction zero = Fraction(0);
    Fraction one = Fraction(1);
    Fraction minusOne = Fraction(-1);

    for (var i = 0; i < _solution.length; i++) {
      if (_numSolution[i] != zero) {
        buffer.write(_numSolution[i]);
      }

      _solution[i]?.forEach((key, value) {
        if (value > zero && _numSolution[i] != zero) {
          buffer.write('+');
        }
        if (value != zero) {
          if (value == minusOne) {
            buffer.write('-');
          } else if (value == one) {
            buffer.write('+');
          } else {
            buffer.write(value);
          }
          buffer.write('x$key');
        }
      });

      if (i != _solution.length - 1) {
        buffer.write('; ');
      }
    }

    buffer.write(')');
    return buffer.toString();
  }

  String toTeX() {
    Fraction zero = Fraction(0);
    Fraction one = Fraction(1);
    Fraction minusOne = Fraction(-1);

    StringBuffer buffer = StringBuffer(r'\begin{pmatrix} ');

    bool notZero = false;
    for (var i = 0; i < _solution.length; i++) {
      if (_numSolution[i] != zero) {
        buffer.write(_numSolution[i]);
        notZero = true;
      }

      _solution[i]?.forEach((key, value) {
        if (value > zero && _numSolution[i] != zero) {
          buffer.write('+');
        }
        if (value != zero) {
          if (value == minusOne) {
            buffer.write('-');
          } else if (value == one && notZero) {
            buffer.write('+');
          } else if (value != one) {
            buffer.write(value);
          }
          buffer.write('x_{$key}');
          notZero = true;
        }
      });

      if (i != _solution.length - 1) {
        buffer.write(r' & ');
      }
      notZero = false;
    }

    buffer.write(r' \end{pmatrix}');
    return buffer.toString();
  }
}
