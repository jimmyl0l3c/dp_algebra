import 'package:algebra_lib/algebra_lib.dart';
import 'package:fraction/fraction.dart';

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

      // TODO: optimize this
      Scalar zero = Scalar.zero();
      List<Expression> numSolution = [];
      Map<int, Map<int, Expression>> solution = {};
      for (var i = 0; i < simplifiedMatrix.columnCount() - 1; i++) {
        solution[i] = {i: Scalar.one()};
        numSolution.add(Scalar.zero());
      }

      for (var r = 0; r < simplifiedMatrix.rowCount(); r++) {
        for (var c = 0; c < simplifiedMatrix.columnCount(); c++) {
          if (simplifiedMatrix[r][c] != zero) {
            for (var i = c + 1; i < simplifiedMatrix.columnCount(); i++) {
              if (i == simplifiedMatrix.columnCount() - 1) {
                // Right side
                numSolution[c] = simplifiedMatrix[r][i];
              } else if (simplifiedMatrix[r][i] != zero) {
                solution[c]?[i] = Scalar(
                  value:
                      (simplifiedMatrix[r][i] as Scalar).value * Fraction(-1),
                );
              }
            }
            solution[c]?.remove(c);
            break;
          }
        }
      }

      List<Expression> solutionVector = [];
      for (var i = 0; i < simplifiedMatrix.columnCount() - 1; i++) {
        if (solution[i] == null || solution[i]!.isEmpty) {
          solutionVector.add(numSolution[i]);
        } else {
          List<Expression> parametrizedScalar = [];
          if (numSolution[i] != zero) {
            parametrizedScalar.add(numSolution[i]);
          }
          solution[i]?.forEach(
            (key, value) => parametrizedScalar.add(Variable(
              n: value,
              param: key,
            )),
          );

          solutionVector.add(ParametrizedScalar(values: parametrizedScalar));
        }
      }
      return Vector(items: solutionVector);
    }

    return GaussianElimination(
      matrix: Reduce(exp: Triangular(matrix: matrix)),
    );
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      'gaussianElimination\\begin{pmatrix}${matrix.toTeX()}\\end{pmatrix}';
}
