import 'dart:math';

import 'package:dp_algebra/matrices/extensions.dart';
import 'package:dp_algebra/matrices/matrix_exceptions.dart';
import 'package:dp_algebra/matrices/vector.dart';
import 'package:dp_algebra/matrices/vector_exceptions.dart';
import 'package:fraction/fraction.dart';

class Matrix {
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

  Matrix.fromVectors(List<Vector> vectors, {bool vertical = false}) {
    if (vectors.isNotEmpty &&
        vectors.any((v) => v.length() != vectors.first.length())) {
      throw VectorSizeMismatchException();
    }

    _defaultVal = 0.toFraction();

    if (vertical) {
      int cols = vectors.length;
      int rows = vectors.first.length();

      for (var r = 0; r < rows; r++) {
        List<Fraction> row = [];
        for (var c = 0; c < cols; c++) {
          row.add(vectors[c][r]);
        }
        _matrix.add(row);
      }
    } else {
      for (var v in vectors) {
        _matrix.add(List<Fraction>.from(v.asList()));
      }
    }
  }

  List<Vector> toVectors({bool vertical = false}) {
    List<Vector> vectors = [];
    if (vertical) {
      for (var c = 0; c < getColumns(); c++) {
        List<Fraction> column = [];
        for (var r = 0; r < getRows(); r++) {
          column.add(_matrix[r][c]);
        }
        vectors.add(Vector.fromList(column));
      }
    } else {
      for (var row in _matrix) {
        vectors.add(Vector.fromList(row));
      }
    }

    return vectors;
  }

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

  List<Fraction> removeColumn(int index) {
    List<Fraction> removed = [];

    for (var row in _matrix) {
      removed.add(row.removeAt(index));
    }

    return removed;
  }

  List<Fraction> removeRow(int index) {
    return _matrix.removeAt(index);
  }

  void setValue(int r, int c, Fraction value) => _matrix[r][c] = value;

  Fraction determinant() {
    if (!isSquare()) throw MatrixIsNotSquareException();
    if (getRows() == 1) return _matrix.first.first;
    if (getRows() == 2) {
      return _matrix[0][0] * _matrix[1][1] - _matrix[0][1] * _matrix[1][0];
    }

    Matrix triangularM = triangular(isDeterminant: true);
    Fraction output = Fraction(1);
    for (var i = 0; i < triangularM.getRows(); i++) {
      output *= triangularM[i][i];
    }
    return output.reduce();
  }

  Matrix transposed() {
    int rows = getRows();
    int cols = getColumns();
    Matrix output = Matrix(rows: cols, columns: rows);
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        output[j][i] = _matrix[i][j].reduce();
      }
    }
    return output;
  }

  Matrix inverse() {
    Fraction det = determinant();
    if (det == Fraction(0)) {
      throw MatrixInverseImpossibleException();
    }

    Matrix inverse = Matrix(rows: getRows(), columns: getColumns());
    for (var r = 0; r < getRows(); r++) {
      for (var c = 0; c < getRows(); c++) {
        inverse[r][c] = algSupplement(c, r);
      }
    }

    return inverse * det.inverse();
  }

  Fraction minor(int row, int column) {
    if (!isSquare()) throw MatrixIsNotSquareException();
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
    return minor.determinant();
  }

  Fraction algSupplement(int row, int column) =>
      pow(-1, row + column + 2).toFraction() * minor(row, column);

  int rank() {
    Matrix m = Matrix.from(this);
    Fraction zero = Fraction(0);
    int rank = 0;

    m.reduce();
    for (var i = 0; i < getRows(); i++) {
      for (var j = 0; j < getColumns(); j++) {
        if (m[i][j] != zero) {
          rank++;
          break;
        }
      }
    }

    return rank;
  }

  Matrix triangular({bool isDeterminant = false}) {
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

  void reduce() {
    Fraction zero = Fraction(0);

    for (var i = 0; i < getRows(); i++) {
      for (var j = 0; j < getColumns(); j++) {
        if (_matrix[i][j] != zero) {
          multiplyRowByN(i, _matrix[i][j].inverse());

          for (var k = 0; k < getRows(); k++) {
            if (k == i) continue;

            addRowToRowNTimes(i, k, _matrix[k][j].negate());
          }

          break;
        }
      }
    }
  }

  void addRowToRowNTimes(int rowOrigin, int rowTarget, Fraction n) {
    if (rowOrigin < 0 ||
        rowTarget < 0 ||
        rowOrigin >= getRows() ||
        rowTarget >= getRows()) {
      throw MatrixOutOfBoundsException();
    }
    int cols = getColumns();
    for (var c = 0; c < cols; c++) {
      _matrix[rowTarget][c] += n * _matrix[rowOrigin][c];
      _matrix[rowTarget][c] = _matrix[rowTarget][c].reduce();
    }
  }

  void multiplyRowByN(int row, Fraction n) {
    if (row < 0 || row >= getRows()) {
      throw MatrixOutOfBoundsException();
    }
    int cols = getColumns();
    for (var c = 0; c < cols; c++) {
      _matrix[row][c] *= n;
      _matrix[row][c] = _matrix[row][c].reduce();
    }
  }

  void exchangeRows(int row1, int row2) {
    if (row1 < 0 || row2 < 0 || row1 >= getRows() || row2 >= getRows()) {
      throw MatrixOutOfBoundsException();
    }
    var tmp = _matrix[row1];
    _matrix[row1] = _matrix[row2];
    _matrix[row2] = tmp;
  }

  bool isSquare() => getRows() == getColumns();

  bool isSameSizeAs(Matrix other) =>
      getRows() == other.getRows() && getColumns() == other.getColumns();

  Matrix doEntryWiseOperation(
    Matrix other,
    Fraction Function(Fraction, Fraction) operation,
    String operationSymbol,
  ) {
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

  Matrix operator +(Matrix other) =>
      doEntryWiseOperation(other, (a, b) => a + b, '+');

  Matrix operator -(Matrix other) =>
      doEntryWiseOperation(other, (a, b) => a - b, '-');

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

  List<Fraction> operator [](int i) => _matrix[i];

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

  String toTeX({bool isDeterminant = false}) {
    if (_matrix.isEmpty) return '()';

    StringBuffer buffer = StringBuffer();
    int rows = getRows();
    int cols = getColumns();

    buffer.write('\\begin{${isDeterminant ? 'v' : 'p'}matrix} ');

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        buffer.write(_matrix[r][c].reduce().toTeX());

        if (c != (cols - 1)) buffer.write(' & ');
      }
      if (r != (rows - 1)) buffer.write(r' \\ ');
    }

    buffer.write(' \\end{${isDeterminant ? 'v' : 'p'}matrix}');
    return buffer.toString();
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
