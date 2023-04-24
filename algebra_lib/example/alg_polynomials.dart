import 'package:algebra_lib/algebra_lib.dart';

import '../test/utils/scalar_provider.dart';

void main() {
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

  final polyWithScalarParams = [
    [ScalarProvider.get(2), testPolynomials[0]],
    [ScalarProvider.get(-4), testPolynomials[0]],
    [testPolynomials[1], ScalarProvider.get(3)],
    [testPolynomials[1], ScalarProvider.get(-1)],
  ];
  for (var params in polyWithScalarParams) {
    Expression addition = Addition(left: params[0], right: params[1]);
    printNSimplifications(addition, 3);
    print('');
  }

  print('\n');

  final polyWithPolyParams = [
    [testPolynomials[0], testPolynomials[0]],
    [testPolynomials[0], testPolynomials[1]],
    [testPolynomials[1], testPolynomials[0]],
    [testPolynomials[1], testPolynomials[1]],
  ];
  for (var params in polyWithPolyParams) {
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
