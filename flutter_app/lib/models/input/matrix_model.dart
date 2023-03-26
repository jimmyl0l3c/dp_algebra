import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/utils/extensions.dart';
import 'package:fraction/fraction.dart';

class MatrixModel {
  List<List<Fraction>> _matrix = List<List<Fraction>>.empty(growable: true);
  late Fraction _defaultVal;

  MatrixModel({int columns = 1, int rows = 1, int defaultValue = 0}) {
    _defaultVal = defaultValue.toFraction();
    for (var i = 0; i < rows; i++) {
      List<Fraction> row = List<Fraction>.empty(growable: true);

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
        _defaultVal = 0.toFraction();

  MatrixModel.from(MatrixModel m)
      : _matrix = m._matrix.map((row) => List<Fraction>.from(row)).toList(),
        _defaultVal = m._defaultVal;

  int get columns => _matrix.isNotEmpty ? _matrix.first.length : 0;
  int get rows => _matrix.length;

  void addColumn() {
    for (var row in _matrix) {
      row.add(_defaultVal);
    }
  }

  void addRow() {
    List<Fraction> row = List<Fraction>.empty(growable: true);

    for (var j = 0; j < columns; j++) {
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

  List<Fraction> operator [](int i) => _matrix[i];

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
                  items: row.map((entry) => Scalar(value: entry)).toList(),
                ))
            .toList(),
        rowCount: rows,
        columnCount: columns,
      );
}
