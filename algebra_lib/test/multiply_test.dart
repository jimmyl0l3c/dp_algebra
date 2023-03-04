import 'package:algebra_lib/algebra_lib.dart';
import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group('Multiply', () {
    final scalarByScalarParams = [
      [
        Scalar(value: Fraction(2)),
        Scalar(value: Fraction(3)),
        Scalar(value: Fraction(6)),
      ],
      [
        Scalar(value: Fraction(-4)),
        Scalar(value: Fraction(5)),
        Scalar(value: Fraction(-20)),
      ],
      [
        Scalar(value: Fraction(7)),
        Scalar(value: Fraction(-1)),
        Scalar(value: Fraction(-7)),
      ],
      [
        Scalar(value: Fraction(-2)),
        Scalar(value: Fraction(-9)),
        Scalar(value: Fraction(18)),
      ],
    ];

    setUp(() {});

    for (var params in scalarByScalarParams) {
      test('Scalars: ${params[0]} * (${params[1]})', () {
        Expression multiply = Multiply(left: params[0], right: params[1]);

        while (multiply is! Scalar) {
          if (multiply is Vector || multiply is Matrix) {
            // TODO: fail
          }
          multiply = multiply.simplify();
        }

        expect(multiply, params[2]);
      }, tags: ['scalar', 'multiply']);
    }
  });
}
