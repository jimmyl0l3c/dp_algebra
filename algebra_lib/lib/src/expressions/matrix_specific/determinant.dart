import 'package:algebra_lib/algebra_lib.dart';

class Determinant implements Expression {
  final Expression det;

  Determinant({required this.det}) {
    if (det is Vector || det is Scalar) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (det is Vector || det is Scalar) {
      throw UndefinedOperationException();
    }

    if (det is TriangularDet) {
      Expression simplifiedTriangular = det.simplify();

      if (simplifiedTriangular is! Matrix) {
        return Determinant(det: simplifiedTriangular);
      }

      Expression out = simplifiedTriangular[0][0];
      for (var i = 1; i < simplifiedTriangular.rowCount(); i++) {
        out = Multiply(left: out, right: simplifiedTriangular[i][i]);
      }
      return out;
    }

    if (det is! Matrix) {
      return Determinant(det: det.simplify());
    }

    Matrix determinant = det.simplify() as Matrix;

    if (determinant.rowCount() != determinant.columnCount()) {
      throw DeterminantNotSquareException();
    }

    // If the matrix contains non-computed expressions, return simplified
    if (determinant != det) {
      return Determinant(det: determinant);
    }

    if (determinant.rowCount() == 1) return determinant[0][0];
    if (determinant.rowCount() == 2) {
      return Subtraction(
        left: Multiply(
          left: determinant[0][0],
          right: determinant[1][1],
        ),
        right: Multiply(
          left: determinant[0][1],
          right: determinant[1][0],
        ),
      );
    }

    return Determinant(det: TriangularDet(det: determinant));
  }

  @override
  String toTeX() => 'det\\begin{vmatrix} ${det.toTeX()} \\end{vmatrix}';
}
