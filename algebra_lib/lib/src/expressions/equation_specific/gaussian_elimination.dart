import 'package:algebra_lib/algebra_lib.dart';
import 'package:algebra_lib/src/expressions/structures/param_scalar.dart';

class GaussianElimination implements Expression {
  final Expression matrix;

  GaussianElimination({required this.matrix}) {
    if (matrix is Scalar || matrix is Vector || matrix is ParametrizedScalar) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (matrix is Scalar || matrix is Vector || matrix is ParametrizedScalar) {
      throw UndefinedOperationException();
    }

    if (matrix is Reduce) {
      Expression simplifiedMatrix = matrix.simplify();
      if (simplifiedMatrix is! Matrix) {
        return GaussianElimination(matrix: simplifiedMatrix);
      }

      // TODO: create the solution
      return GaussianElimination(matrix: matrix.simplify());
    }

    return GaussianElimination(
      matrix: Reduce(exp: Triangular(matrix: matrix)),
    );
  }

  @override
  String toTeX() {
    // TODO: implement toTeX
    throw UnimplementedError();
  }
}
