import 'package:dp_algebra/matrices/matrix_exceptions.dart';
import 'package:fraction/fraction.dart';

class Matrix {
  List<List<Fraction>> _matrix = List<List<Fraction>>.empty(growable: true);
  Object?
      _stepByStep; // TODO: implement: Object containing steps of last (or last n) operations
  late Fraction _defaultVal;

  Matrix({int columns = 1, int rows = 1, int defaultValue = 0}) {
    _defaultVal = defaultValue.toFraction();
    for (var i = 0; i < rows; i++) {
      addRow();
    }
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

  Fraction getDeterminant() {
    // TODO: implement
    throw UnimplementedError();
  }

  int getRank() {
    // TODO: implement
    throw UnimplementedError();
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
}
