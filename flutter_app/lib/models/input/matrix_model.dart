import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/models/input/vector_model.dart';
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
            .map((row) => row.map((e) => (e as Scalar).value).toList())
            .toList(),
        _defaultVal = 0.toFraction();

  MatrixModel.from(MatrixModel m)
      : _matrix = m._matrix.map((row) => List<Fraction>.from(row)).toList(),
        _defaultVal = m._defaultVal;

  MatrixModel.fromVectors(List<VectorModel> vectors, {bool vertical = false}) {
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

  List<VectorModel> toVectors({bool vertical = false}) {
    List<VectorModel> vectors = [];
    if (vertical) {
      for (var c = 0; c < getColumns(); c++) {
        List<Fraction> column = [];
        for (var r = 0; r < getRows(); r++) {
          column.add(_matrix[r][c]);
        }
        vectors.add(VectorModel.fromList(column));
      }
    } else {
      for (var row in _matrix) {
        vectors.add(VectorModel.fromList(row));
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

  MatrixModel transposed() {
    int rows = getRows();
    int cols = getColumns();
    MatrixModel output = MatrixModel(rows: cols, columns: rows);
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        output[j][i] = _matrix[i][j].reduce();
      }
    }
    return output;
  }

  bool isSquare() => getRows() == getColumns();

  bool isSameSizeAs(MatrixModel other) =>
      getRows() == other.getRows() && getColumns() == other.getColumns();

  @override
  bool operator ==(Object other) {
    if (other is! MatrixModel) return false;
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
  int get hashCode => _matrix.hashCode;

  Matrix toMatrix() => Matrix(
        rows: _matrix
            .map((row) => row.map((entry) => Scalar(value: entry)).toList())
            .toList(),
      );
}
