import 'package:algebra_lib/algebra_lib.dart';

class Matrix implements Expression {
  final List<List<Expression>> items; // TODO: rename, rows?

  Matrix({required this.items}); // TODO: check size, throw exception

  int rows() => items.length;
  int columns() => items.isNotEmpty ? items.first.length : 0;

  List<Expression> operator [](int i) => items[i];

  @override
  Expression simplify() {
    for (var r = 0; r < items.length; r++) {
      for (var c = 0; c < items.length; c++) {
        if (items[r][c] is! Scalar) {
          List<List<Expression>> simplifiedItems =
              items.map((row) => List<Expression>.from(row)).toList();
          simplifiedItems[r][c] = items[r][c].simplify();

          return Matrix(items: simplifiedItems);
        }
      }
    }
    return this;
  }

  @override
  String toTeX() {
    if (items.isEmpty) return '()';

    StringBuffer buffer = StringBuffer(r'\begin{pmatrix} ');
    int rows = items.length;
    int cols = items.first.length;

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        buffer.write(items[r][c].toTeX());

        if (c != (cols - 1)) buffer.write(' & ');
      }
      if (r != (rows - 1)) buffer.write(r' \\ ');
    }

    buffer.write(r' \end{pmatrix}');
    return buffer.toString();
  }
}
