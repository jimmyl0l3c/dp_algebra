import 'package:algebra_lib/algebra_lib.dart';
import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group('Multiply', () {
    final scalar1 = Scalar(value: 5.toFraction());
    final scalar2 = Scalar(value: 6.toFraction());

    setUp(() {
      // Additional setup goes here.
    });

    test('Multiply scalars', () {
      var multiply = Multiply(left: scalar1, right: scalar2);
      // TODO: write better tests
      expect(multiply.simplify().toTeX(), equals('30'));
    });
  });
}
