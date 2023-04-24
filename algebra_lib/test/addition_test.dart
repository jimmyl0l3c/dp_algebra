import 'package:algebra_lib/algebra_lib.dart';
import 'package:test/test.dart';

import 'utils/exp_simplifier.dart';
import 'utils/scalar_provider.dart';

void main() {
  // TODO: test error states
  group('Addition', () {
    final testParamScalars = [
      ParametrizedScalar(values: [
        Variable(n: ScalarProvider.get(2), param: 0),
        Variable(n: ScalarProvider.get(1), param: 1),
        Variable(n: ScalarProvider.get(-3), param: 2),
      ]),
      ParametrizedScalar(values: [
        Variable(n: ScalarProvider.get(1), param: 0),
        Variable(n: ScalarProvider.get(-3), param: 2),
        ScalarProvider.get(3),
      ]),
    ];

    setUp(() {});

    final pScalarWithScalarParams = [
      [
        ScalarProvider.get(2),
        testParamScalars[0],
        ParametrizedScalar(values: [
          Variable(n: ScalarProvider.get(2), param: 0),
          Variable(n: ScalarProvider.get(1), param: 1),
          Variable(n: ScalarProvider.get(-3), param: 2),
          ScalarProvider.get(2),
        ]),
      ],
      [
        ScalarProvider.get(-4),
        testParamScalars[0],
        ParametrizedScalar(values: [
          Variable(n: ScalarProvider.get(2), param: 0),
          Variable(n: ScalarProvider.get(1), param: 1),
          Variable(n: ScalarProvider.get(-3), param: 2),
          ScalarProvider.get(-4),
        ]),
      ],
      [
        testParamScalars[1],
        ScalarProvider.get(3),
        ParametrizedScalar(values: [
          Variable(n: ScalarProvider.get(1), param: 0),
          Variable(n: ScalarProvider.get(-3), param: 2),
          ScalarProvider.get(6),
        ]),
      ],
      [
        testParamScalars[1],
        ScalarProvider.get(-1),
        ParametrizedScalar(values: [
          Variable(n: ScalarProvider.get(1), param: 0),
          Variable(n: ScalarProvider.get(-3), param: 2),
          ScalarProvider.get(2),
        ]),
      ],
    ];
    for (var params in pScalarWithScalarParams) {
      test('ParamScalar + scalar: ${params[0]} + (${params[1]})', () {
        Expression addition = Addition(left: params[0], right: params[1]);

        var result = ExpSimplifier.simplifyCompletely(addition);

        expect(result, params[2]);
      }, tags: ['scalar', 'parametrized_scalar', 'addition']);
    }
  });
}
