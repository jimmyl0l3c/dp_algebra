import 'package:algebra_lib/algebra_lib.dart';
import 'package:fraction/fraction.dart';

class Reduce implements Expression {
  final Expression exp;

  Reduce({required this.exp}) {
    if (exp is Vector) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (exp is Vector) {
      throw UndefinedOperationException();
    }

    if (exp is! Scalar && exp is! Matrix) {
      return Reduce(exp: exp.simplify());
    }

    if (exp is Scalar) {
      return Scalar(value: (exp as Scalar).value.reduce());
    }

    Matrix m = exp.simplify() as Matrix;

    // If the matrix contains non-computed expressions, return simplified
    if (m != exp) {
      return Reduce(exp: m);
    }

    Scalar zero = Scalar.zero();
    Scalar one = Scalar.one();
    Scalar nOne = Scalar(value: Fraction(-1));

    for (var i = 0; i < m.rowCount(); i++) {
      for (var j = 0; j < m.columnCount(); j++) {
        if (m[i][j] != zero) {
          if (m[i][j] != one) {
            return Reduce(
              exp: MultiplyRowByN(
                matrix: m,
                n: Inverse(exp: m[i][j]),
                row: i,
              ),
            );
          }

          for (var k = 0; k < m.rowCount(); k++) {
            if (k == i) continue;

            if (m[k][j] != zero) {
              return Reduce(
                exp: AddRowToRowNTimes(
                  matrix: m,
                  origin: i,
                  target: k,
                  n: Multiply(left: nOne, right: m[k][j]),
                ),
              );
            }
          }

          break;
        }
      }
    }

    return m;
  }

  @override
  String toTeX() => 'reduce ${exp.toTeX()}';
}
