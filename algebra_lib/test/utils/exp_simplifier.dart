import 'package:algebra_lib/algebra_lib.dart';

class ExpSimplifier {
  static Expression simplifyCompletely(Expression expression) {
    Expression previousExp = expression;
    Expression currentExp = expression.simplify();

    while (previousExp != currentExp) {
      previousExp = currentExp;
      currentExp = currentExp.simplify();
    }

    return currentExp;
  }
}
