import 'package:algebra_lib/algebra_lib.dart';

class Transpose implements Expression {
  final Expression matrix;

  Transpose({required this.matrix}) {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is! Matrix) {
      return Transpose(matrix: matrix.simplify());
    }

    Matrix m = matrix as Matrix;
    List<List<Expression>> transposedMatrix = [];

    for (var r = 0; r < m.columnCount(); r++) {
      List<Expression> row = [];
      for (var c = 0; c < m.rowCount(); c++) {
        row.add(m[c][r]);
      }
      transposedMatrix.add(row);
    }

    return Matrix(rows: transposedMatrix);
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      '\\begin{pmatrix}${matrix.toTeX(flags: {
            TexFlags.dontEnclose,
          })}\\end{pmatrix}^{T}';
}
