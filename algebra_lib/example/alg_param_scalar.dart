import 'package:algebra_lib/algebra_lib.dart';

import '../test/utils/scalar_provider.dart';

void main() {
  final testParamScalar = [
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

  final paramScalarWithScalarParams = [
    [ScalarProvider.get(2), testParamScalar[0]],
    [ScalarProvider.get(-4), testParamScalar[0]],
    [testParamScalar[1], ScalarProvider.get(3)],
    [testParamScalar[1], ScalarProvider.get(-1)],
  ];
  for (var params in paramScalarWithScalarParams) {
    Expression addition = Addition(left: params[0], right: params[1]);
    printNSimplifications(addition, 3);
    print('');

    Expression multiply = Multiply(left: params[0], right: params[1]);
    printNSimplifications(multiply, 6);
    print('');
  }

  print('\n');

  final paramScalarWithParamScalarsTest = [
    [testParamScalar[0], testParamScalar[0]],
    [testParamScalar[0], testParamScalar[1]],
    [testParamScalar[1], testParamScalar[0]],
    [testParamScalar[1], testParamScalar[1]],
  ];
  for (var params in paramScalarWithParamScalarsTest) {
    Expression addition = Addition(left: params[0], right: params[1]);
    printNSimplifications(addition, 6);
    print('');
  }
}

void printNSimplifications(Expression expression, int n,
    {bool addNewLine = false}) {
  for (var i = 0; i < n; i++) {
    print(simplifyNTimes(expression, i).toTeX());
    if (addNewLine) {
      print("");
    }
  }
}

Expression simplifyNTimes(Expression expression, int n) {
  Expression exp = expression;
  for (var i = 0; i < n; i++) {
    exp = exp.simplify();
  }
  return exp;
}
