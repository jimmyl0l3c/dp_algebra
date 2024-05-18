import 'package:algebra_lib/algebra_lib.dart';
import 'package:algebra_lib/src/utils/exp_utils.dart';
import 'package:test/test.dart';

import 'utils/scalar_provider.dart';

void main() {
  group('Addition', () {
    final testVectors = [
      Vector(items: [
        ScalarProvider.get(7),
        ScalarProvider.get(3),
        ScalarProvider.get(-2),
      ]),
      Vector(items: [
        ScalarProvider.get(1),
        ScalarProvider.get(2),
        ScalarProvider.get(3),
      ]),
      Vector(items: [
        ScalarProvider.get(4),
        ScalarProvider.get(5),
        ScalarProvider.get(6),
        ScalarProvider.get(7),
      ]),
      Vector(items: [
        ScalarProvider.get(2),
        ScalarProvider.get(-1),
        ScalarProvider.get(8),
        ScalarProvider.get(-2),
      ]),
    ];

    setUp(() {});

    final scalarWithScalarParams = [
      [ScalarProvider.get(2), ScalarProvider.get(3), ScalarProvider.get(5)],
      [ScalarProvider.get(-4), ScalarProvider.get(5), ScalarProvider.get(1)],
      [ScalarProvider.get(7), ScalarProvider.get(-1), ScalarProvider.get(6)],
      [ScalarProvider.get(-2), ScalarProvider.get(-9), ScalarProvider.get(-11)],
    ];
    for (var params in scalarWithScalarParams) {
      test('Scalars: ${params[0]} + (${params[1]})', () {
        Expression add = Addition(left: params[0], right: params[1]);

        var result = simplifyAsMuchAsPossible(add);

        expect(result, params[2]);
      }, tags: ['scalar', 'addition']);
    }

    final vectorWithVectorParams = [
      [
        testVectors[0],
        testVectors[1],
        Vector(items: [
          ScalarProvider.get(8),
          ScalarProvider.get(5),
          ScalarProvider.get(1),
        ])
      ],
      [
        testVectors[2],
        testVectors[3],
        Vector(items: [
          ScalarProvider.get(6),
          ScalarProvider.get(4),
          ScalarProvider.get(14),
          ScalarProvider.get(5),
        ])
      ],
    ];
    for (var params in vectorWithVectorParams) {
      test('Vectors: ${params[0]} + (${params[1]})', () {
        Expression add = Addition(left: params[0], right: params[1]);

        var result = simplifyAsMuchAsPossible(add);

        expect(result, params[2]);
      }, tags: ['vector', 'addition']);
    }

    final mismatchedVectorsParams = [
      [testVectors[0], testVectors[2]],
      [testVectors[3], testVectors[1]],
      [testVectors[2], testVectors[0]],
    ];
    for (var params in mismatchedVectorsParams) {
      test('MismatchedVectors: ${params[0]} + (${params[1]})', () {
        Expression add = Addition(left: params[0], right: params[1]);

        expect(
          () => add.simplify(),
          throwsA(TypeMatcher<VectorSizeMismatchException>()),
        );
      }, tags: ['vector', 'addition']);
    }
  });

  // TODO: test matrix addition
  // TODO: test matrix size mismatch exc
  // TODO: test variables
  // TODO: test scalar and variable
  // TODO: test commutative group related addition in separate test file
}
