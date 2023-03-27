import 'package:algebra_lib/algebra_lib.dart';
import 'package:precise_fractions/precise_fractions.dart';

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
    Scalar nOne = Scalar(value: PreciseFraction.minusOne());

    for (var i = 0; i < m.rowCount; i++) {
      for (var j = 0; j < m.columnCount; j++) {
        if ((m[i] as Vector)[j] != zero) {
          if ((m[i] as Vector)[j] != one) {
            return Reduce(
              exp: MultiplyRowByN(
                matrix: m,
                n: Inverse(exp: (m[i] as Vector)[j]),
                row: i,
              ),
            );
          }

          for (var k = 0; k < m.rowCount; k++) {
            if (k == i) continue;

            if ((m[k] as Vector)[j] != zero) {
              return Reduce(
                exp: AddRowToRowNTimes(
                  matrix: m,
                  origin: i,
                  target: k,
                  n: Multiply(left: nOne, right: (m[k] as Vector)[j]),
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
  String toTeX({Set<TexFlags>? flags}) =>
      'reduce\\begin{pmatrix}${exp.toTeX(flags: {
            TexFlags.dontEnclose,
          })}\\end{pmatrix}';
}
