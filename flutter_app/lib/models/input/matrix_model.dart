import 'dart:math';

import 'package:algebra_expressions/algebra_expressions.dart';
import 'package:big_fraction/big_fraction.dart';

import '../../utils/extensions.dart';
import 'vector_model.dart';

class MatrixModel {
  List<List<BigFraction>> _matrix =
      List<List<BigFraction>>.empty(growable: true);
  late BigFraction _defaultVal;

  MatrixModel({int columns = 1, int rows = 1, int defaultValue = 0}) {
    _defaultVal = defaultValue.toBigFraction();
    for (var i = 0; i < rows; i++) {
      List<BigFraction> row = List<BigFraction>.empty(growable: true);

      for (var j = 0; j < columns; j++) {
        row.add(_defaultVal);
      }

      _matrix.add(row);
    }
  }

  MatrixModel.fromMatrix(Matrix m)
      : _matrix = m.rows
            .map((row) =>
                (row as Vector).items.map((e) => (e as Scalar).value).toList())
            .toList(),
        _defaultVal = 0.toBigFraction();

  MatrixModel.from(MatrixModel m)
      : _matrix = m._matrix.map((row) => List<BigFraction>.from(row)).toList(),
        _defaultVal = m._defaultVal;

  int get columns => _matrix.isNotEmpty ? _matrix.first.length : 0;
  int get rows => _matrix.length;

  void addColumn() {
    for (var row in _matrix) {
      row.add(_defaultVal);
    }
  }

  void addRow() {
    List<BigFraction> row = List<BigFraction>.empty(growable: true);

    for (var j = 0; j < columns; j++) {
      row.add(_defaultVal);
    }

    _matrix.add(row);
  }

  List<BigFraction> removeColumn(int index) {
    List<BigFraction> removed = [];

    for (var row in _matrix) {
      removed.add(row.removeAt(index));
    }

    return removed;
  }

  List<BigFraction> removeRow(int index) {
    return _matrix.removeAt(index);
  }

  void clear() {
    _matrix.clear();
    _matrix.add([_defaultVal]);
  }

  void regenerateValues() {
    Random r = Random();

    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < columns; j++) {
        _matrix[i][j] = BigFraction.from(r.nextInt(21) - 10);
      }
    }
  }

  void setValue(int r, int c, BigFraction value) => _matrix[r][c] = value;

  bool get isSquare => rows == columns;

  bool isSameSizeAs(MatrixModel other) =>
      rows == other.rows && columns == other.columns;

  @override
  bool operator ==(Object other) {
    if (other is! MatrixModel) return false;
    if (!isSameSizeAs(other)) return false;
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < columns; c++) {
        if (_matrix[r][c] != other[r][c]) return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_matrix);

  List<BigFraction> operator [](int i) => _matrix[i];

  @override
  String toString() {
    StringBuffer buffer = StringBuffer('(');
    int rows = this.rows;
    int cols = columns;

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
    int rows = this.rows;
    int cols = columns;

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

  Matrix toMatrix() => Matrix(
        rows: _matrix
            .map((row) => Vector(
                  items: row.map((entry) => Scalar(entry)).toList(),
                ))
            .toList(),
        rowCount: rows,
        columnCount: columns,
      );

  List<VectorModel> toVectorModels() =>
      _matrix.map((r) => VectorModel.fromList(r)).toList();
}
