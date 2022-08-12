import 'dart:math';

import 'package:dp_algebra/matrices/matrix_exceptions.dart';
import 'package:fraction/fraction.dart';

class Matrix {
  // TODO: reduce fractions after operations (namely after transformations)
  List<List<Fraction>> _matrix = List<List<Fraction>>.empty(growable: true);
  Object?
      _stepByStep; // TODO: implement: Object containing steps of last (or last n) operation(s)
  late Fraction _defaultVal;

  Matrix({int columns = 1, int rows = 1, int defaultValue = 0}) {
    _defaultVal = defaultValue.toFraction();
    for (var i = 0; i < rows; i++) {
      List<Fraction> row = List<Fraction>.empty(growable: true);

      for (var j = 0; j < columns; j++) {
        row.add(_defaultVal);
      }

      _matrix.add(row);
    }
  }

  Matrix.from(Matrix m)
      : _matrix = m._matrix.map((row) => List<Fraction>.from(row)).toList(),
        _stepByStep = m._stepByStep,
        _defaultVal = m._defaultVal;

  int getColumns() => _matrix.isNotEmpty ? _matrix.first.length : 0;
  int getRows() => _matrix.length;

  void addColumn() {
    for (var row in _matrix) {
      row.add(_defaultVal);
    }
  }

  void addRow() {
    List<Fraction> row = List<Fraction>.empty(growable: true);

    for (var j = 0; j < getColumns(); j++) {
      row.add(_defaultVal);
    }

    _matrix.add(row);
  }

  void setValue(int r, int c, Fraction value) => _matrix[r][c] = value;

  Fraction getDeterminant() {
    if (getRows() != getColumns()) throw MatrixIsNotSquareException();
    if (getRows() == 1) return _matrix.first.first;
    if (getRows() == 2) {
      return _matrix[0][0] * _matrix[1][1] - _matrix[0][1] * _matrix[1][0];
    }

    Matrix triangular = getTriangular(isDeterminant: true);
    Fraction output = Fraction(1);
    for (var i = 0; i < triangular.getRows(); i++) {
      output *= triangular[i][i];
    }
    return output.reduce();
  }

  Matrix getTransposed() {
    int rows = getRows();
    int cols = getColumns();
    Matrix output = Matrix(rows: cols, columns: rows);
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        output[j][i] = _matrix[i][j];
      }
    }
    return output;
  }

  Matrix? getInverse() {
    Fraction determinant = getDeterminant();
    if (determinant == Fraction(0)) {
      throw MatrixInverseImpossibleException();
    }

    Matrix inverse = Matrix(rows: getRows(), columns: getColumns());
    for (var r = 0; r < getRows(); r++) {
      for (var c = 0; c < getRows(); c++) {
        inverse[r][c] = getAlgSupplement(c, r);
      }
    }

    return inverse * determinant.inverse();
  }

  Fraction getMinor(int row, int column) {
    if (getRows() != getColumns()) throw MatrixIsNotSquareException();
    int n = getRows();
    if (row < 0 || column < 0 || row >= n || column >= n) {
      throw MatrixOutOfBoundsException();
    }

    // Skip row and column
    Matrix minor = Matrix(rows: n - 1, columns: n - 1);
    int rInc = 0, cInc = 0;
    for (var r = 0; r < n; r++) {
      if (r == row) {
        rInc++;
        continue;
      }
      cInc = 0;
      for (var c = 0; c < n; c++) {
        if (c == column) {
          cInc++;
          continue;
        }
        minor[r - rInc][c - cInc] = _matrix[r][c];
      }
    }
    return minor.getDeterminant();
  }

  Fraction getAlgSupplement(int row, int column) =>
      pow(-1, row + column + 2).toFraction() * getMinor(row, column);

  int getRank() {
    // TODO: implement
    throw UnimplementedError();
  }

  Matrix getTriangular({bool isDeterminant = false}) {
    int diagonal = min(getColumns(), getRows());
    Matrix triangular = Matrix.from(this);
    // Optimizations
    Fraction zero = Fraction(0);
    Fraction one = Fraction(1);
    Fraction nOne = Fraction(-1);

    for (var i = 0; i < (diagonal - 1); i++) {
      int? nonZero;
      // Find row with non-zero value
      for (var j = 0; j < (getRows() - i); j++) {
        if (triangular[j + i][i] != zero) {
          nonZero = j + i;
          // Prefer 1 over other non-zero values
          if (triangular[j + i][i] == one) break;
        }
      }
      if (nonZero == null) continue;

      // Exchange rows if necessary
      if (nonZero != i) {
        triangular.exchangeRows(i, nonZero);
        if (isDeterminant) triangular.multiplyRowByN(nonZero, nOne);
      }

      // Clear remaining rows
      for (var j = 0; j < (getRows() - i - 1); j++) {
        int row = i + 1 + j;
        if (triangular[row][i] == zero) continue;
        triangular.addRowToRowNTimes(
            i, row, triangular[row][i].negate() / triangular[i][i]);
      }
    }
    return triangular;
  }

  void addRowToRowNTimes(int rowOrigin, int rowTarget, Fraction n) {
    // TODO: check if parameters arent out of bounds
    int cols = getColumns();
    for (var c = 0; c < cols; c++) {
      _matrix[rowTarget][c] += n * _matrix[rowOrigin][c];
    }
  }

  void multiplyRowByN(int row, Fraction n) {
    int cols = getColumns();
    for (var c = 0; c < cols; c++) {
      _matrix[row][c] *= n;
    }
  }

  void exchangeRows(int row1, int row2) {
    var tmp = _matrix[row1];
    _matrix[row1] = _matrix[row2];
    _matrix[row2] = tmp;
  }

  bool isSameSizeAs(Matrix other) =>
      getRows() == other.getRows() && getColumns() == other.getColumns();

  Matrix entryWiseOperation(
      Matrix other, Fraction Function(Fraction, Fraction) operation) {
    if (!isSameSizeAs(other)) throw MatrixSizeMismatchException();

    int rows = getRows();
    int cols = getColumns();
    Matrix output = Matrix(rows: rows, columns: cols);

    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        output[i][j] = operation(_matrix[i][j], other[i][j]);
      }
    }

    return output;
  }

  @override
  bool operator ==(Object other) {
    if (other is! Matrix) return false;
    int rows = getRows();
    int cols = getColumns();
    if (rows != other.getRows()) return false;
    if (cols != other.getColumns()) return false;
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        if (_matrix[r][c] != other[r][c]) return false;
      }
    }
    return true;
  }

  Matrix operator +(Matrix other) => entryWiseOperation(other, (a, b) => a + b);

  Matrix operator -(Matrix other) => entryWiseOperation(other, (a, b) => a - b);

  Matrix operator *(dynamic other) {
    if (other is Fraction) {
      int rows = getRows();
      int cols = getColumns();
      Matrix output = Matrix(rows: rows, columns: cols);

      for (var i = 0; i < rows; i++) {
        for (var j = 0; j < cols; j++) {
          output[i][j] = _matrix[i][j] * other;
        }
      }
      return output;
    } else if (other is Matrix) {
      int thisCols = getColumns();
      if (thisCols != other.getRows()) throw MatrixMultiplySizeException();

      int rows = getRows();
      int cols = other.getColumns();
      Matrix output = Matrix(rows: rows, columns: cols);

      for (var ra = 0; ra < rows; ra++) {
        for (var cb = 0; cb < cols; cb++) {
          Fraction x = 0.toFraction();
          for (var i = 0; i < thisCols; i++) {
            x += _matrix[ra][i] * other[i][cb];
          }
          output[ra][cb] = x;
        }
      }
      return output;
    } else {
      throw InvalidTypeException();
    }
  }

  List<Fraction> operator [](int i) {
    return _matrix[i];
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer('(');
    int rows = getRows();
    int cols = getColumns();

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        if (c == cols - 1) {
          buffer.write(_matrix[r][c].reduce().toString());
        } else {
          buffer.write('${_matrix[r][c].reduce().toString()}, ');
        }
      }
      if (r != rows - 1) {
        buffer.write('; ');
      }
    }
    buffer.write(')');
    return buffer.toString();
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
