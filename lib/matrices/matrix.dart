import 'package:dp_algebra/matrices/matrix_exceptions.dart';
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
    // TODO: implement
    throw UnimplementedError();
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
    // TODO: implement
    throw UnimplementedError();
  }

  int getRank() {
    // TODO: implement
    throw UnimplementedError();
  }

  void addRowToRowNTimes(int rowOrigin, int rowTarget, Fraction n) {
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
