import 'package:algebra_lib/algebra_lib.dart';
import 'package:collection/collection.dart';

class Matrix implements Expression {
  final List<List<Expression>> rows;

  Matrix({required this.rows}) {
    int? length;
    for (var row in rows) {
      length ??= row.length;

      if (row.length != length) throw MatrixRowSizeMismatchException();
    }
  }

  int rowCount() => rows.length;
  int columnCount() => rows.isNotEmpty ? rows.first.length : 0;

  List<Expression> operator [](int i) => rows[i];

  factory Matrix.fromVectors(List<Vector> vectors, {bool vertical = false}) {
    if (vectors.isNotEmpty &&
        vectors.any((v) => v.length() != vectors.first.length())) {
      throw VectorSizeMismatchException();
    }

    if (vertical) {
      List<List<Expression>> matrixRows = [];
      for (var r = 0; r < vectors.first.length(); r++) {
        List<Expression> matrixRow = [];
        for (var c = 0; c < vectors.length; c++) {
          matrixRow.add(vectors[c][r]);
        }
        matrixRows.add(matrixRow);
      }
      return Matrix(rows: matrixRows);
    }

    return Matrix(rows: vectors.map((v) => v.items).toList());
  }

  factory Matrix.toEquationMatrix(Matrix matrix, Vector vectorY) {
    List<List<Expression>> matrixRows = matrix.rows.mapIndexed((i, r) {
      List<Expression> row = List.from(r)..add(vectorY[i]);
      return row;
    }).toList();

    return Matrix(rows: matrixRows);
  }

  @override
  Expression simplify() {
    for (var r = 0; r < rowCount(); r++) {
      for (var c = 0; c < columnCount(); c++) {
        if (rows[r][c] is! Scalar) {
          List<List<Expression>> simplifiedItems =
              rows.map((row) => List<Expression>.from(row)).toList();
          simplifiedItems[r][c] = rows[r][c].simplify();

          return Matrix(rows: simplifiedItems);
        }
      }
    }
    return this;
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    if (this.rows.isEmpty) return '()';

    StringBuffer buffer = StringBuffer();

    if (flags != null && flags.contains(TexFlags.dontEnclose)) {
      buffer.write(r'\begin{matrix}');
    } else {
      buffer.write(r'\begin{pmatrix}');
    }

    int rows = rowCount();
    int cols = columnCount();

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        buffer.write(this.rows[r][c].toTeX());

        if (c != (cols - 1)) buffer.write(' & ');
      }
      if (r != (rows - 1)) buffer.write(r' \\ ');
    }

    if (flags != null && flags.contains(TexFlags.dontEnclose)) {
      buffer.write(r'\end{matrix}');
    } else {
      buffer.write(r'\end{pmatrix}');
    }
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (other is Matrix) {
      for (var r = 0; r < rowCount(); r++) {
        for (var c = 0; c < columnCount(); c++) {
          if (this[r][c] != other[r][c]) return false;
        }
      }
      return true;
    }
    return false;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => rows.hashCode;
}
