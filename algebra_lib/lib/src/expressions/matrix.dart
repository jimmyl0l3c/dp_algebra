import 'package:algebra_lib/algebra_lib.dart';

// TODO: override equality
class Matrix implements Expression {
  final List<List<Expression>> rows;

  Matrix({required this.rows}) {
    int? length;
    for (var row in rows) {
      length ??= row.length;

      if (row.length != length) throw MatrixRowSizeMismatchException();
    }
  }

  int rowsCount() => rows.length;
  int columnCount() => rows.isNotEmpty ? rows.first.length : 0;

  List<Expression> operator [](int i) => rows[i];

  @override
  Expression simplify() {
    for (var r = 0; r < rowsCount(); r++) {
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
  String toTeX() {
    if (this.rows.isEmpty) return '()';

    StringBuffer buffer = StringBuffer(r'\begin{pmatrix} ');
    int rows = rowsCount();
    int cols = columnCount();

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        buffer.write(this.rows[r][c].toTeX());

        if (c != (cols - 1)) buffer.write(' & ');
      }
      if (r != (rows - 1)) buffer.write(r' \\ ');
    }

    buffer.write(r' \end{pmatrix}');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (other is Matrix) {
      for (var r = 0; r < rowsCount(); r++) {
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
