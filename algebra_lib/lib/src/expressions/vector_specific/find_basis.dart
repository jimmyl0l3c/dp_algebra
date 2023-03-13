import 'package:algebra_lib/algebra_lib.dart';

class FindBasis implements Expression {
  final Expression matrix;

  FindBasis({required this.matrix}) {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is Reduce) {
      Expression simplifiedMatrix = matrix.simplify();
      if (simplifiedMatrix is! Matrix) {
        return FindBasis(matrix: simplifiedMatrix);
      }

      List<List<Expression>> basis = [];
      Scalar zero = Scalar.zero();
      for (var row in simplifiedMatrix.rows) {
        if (row.any((c) => c != zero)) {
          basis.add(row);
        }
      }

      return ExpressionSet(items: basis.map((v) => Vector(items: v)).toSet());
    }

    if (matrix is! Matrix) {
      return FindBasis(matrix: matrix.simplify());
    }

    Matrix m = matrix.simplify() as Matrix;

    // If the matrix contains non-computed expressions, return simplified
    if (m != matrix) {
      return FindBasis(matrix: m);
    }

    return FindBasis(matrix: Reduce(exp: Triangular(matrix: m)));
  }

  @override
  String toTeX({Set<TexFlags>? flags}) => 'basis(${matrix.toTeX()})';
}
