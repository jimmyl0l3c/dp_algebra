import 'package:algebra_lib/algebra_lib.dart';
import 'package:test/test.dart';

import 'utils/exp_simplifier.dart';
import 'utils/scalar_provider.dart';

void main() {
  // TODO: test error states
  group('Addition', () {
    final testPolynomials = [
      Polynomial(values: [
        Variable(n: ScalarProvider.get(2), param: 0),
        Variable(n: ScalarProvider.get(1), param: 1),
        Variable(n: ScalarProvider.get(-3), param: 2),
      ]),
      Polynomial(values: [
        Variable(n: ScalarProvider.get(1), param: 0),
        Variable(n: ScalarProvider.get(-3), param: 2),
        ScalarProvider.get(3),
      ]),
    ];

    setUp(() {});

    final polyWithScalarParams = [
      [
        ScalarProvider.get(2),
        testPolynomials[0],
        Polynomial(values: [
          Variable(n: ScalarProvider.get(2), param: 0),
          Variable(n: ScalarProvider.get(1), param: 1),
          Variable(n: ScalarProvider.get(-3), param: 2),
          ScalarProvider.get(2),
        ]),
      ],
      [
        ScalarProvider.get(-4),
        testPolynomials[0],
        Polynomial(values: [
          Variable(n: ScalarProvider.get(2), param: 0),
          Variable(n: ScalarProvider.get(1), param: 1),
          Variable(n: ScalarProvider.get(-3), param: 2),
          ScalarProvider.get(-4),
        ]),
      ],
      [
        testPolynomials[1],
        ScalarProvider.get(3),
        Polynomial(values: [
          Variable(n: ScalarProvider.get(1), param: 0),
          Variable(n: ScalarProvider.get(-3), param: 2),
          ScalarProvider.get(6),
        ]),
      ],
      [
        testPolynomials[1],
        ScalarProvider.get(-1),
        Polynomial(values: [
          Variable(n: ScalarProvider.get(1), param: 0),
          Variable(n: ScalarProvider.get(-3), param: 2),
          ScalarProvider.get(2),
        ]),
      ],
    ];
    for (var params in polyWithScalarParams) {
      test('Polynomial + scalar: ${params[0]} + (${params[1]})', () {
        Expression addition = Addition(left: params[0], right: params[1]);

        var result = ExpSimplifier.simplifyCompletely(addition);

        expect(result, params[2]);
      }, tags: ['scalar', 'polynomial', 'addition']);
    }
  });
}
