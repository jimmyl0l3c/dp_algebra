import 'package:algebra_lib/algebra_lib.dart';
import 'package:algebra_lib/src/expressions/structures/variable.dart';

class GaussianElimination implements Expression {
  final Expression matrix;

  GaussianElimination({required this.matrix}) {
    if (matrix is Scalar || matrix is Vector || matrix is Variable) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (matrix is Scalar || matrix is Vector || matrix is Variable) {
      throw UndefinedOperationException();
    }

    if (matrix is Reduce) {
      Expression simplifiedMatrix = matrix.simplify();
      if (simplifiedMatrix is! Matrix) {
        return GaussianElimination(matrix: simplifiedMatrix);
      }

      Scalar zero = Scalar.zero();
      List<Expression> numSolution = [];
      for (var r = 0; r < simplifiedMatrix.rowCount(); r++) {
        for (var c = 0; c < simplifiedMatrix.columnCount(); c++) {
          if (simplifiedMatrix[r][c] != zero) {
            for (var i = c + 1; i < simplifiedMatrix.columnCount(); i++) {
              if (i == simplifiedMatrix.columnCount() - 1) {
                // Right side
                numSolution.add(simplifiedMatrix[r][i]);
              } else {}
            }
            break;
          }

          if (c == simplifiedMatrix.columnCount() - 1) {
            numSolution.add(Scalar.zero());
          }
        }
      }
      // TODO: implement GeneralSolution, use ParametrizedScalar with Variable
      return Vector(items: numSolution);
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
