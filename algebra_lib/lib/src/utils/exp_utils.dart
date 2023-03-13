import 'package:algebra_lib/algebra_lib.dart';

class ExpUtils {
  static Expression simplifyAsMuchAsPossible(Expression exp) {
    Expression prevExp = exp;
    Expression lastExp = exp.simplify();

    while (prevExp != lastExp) {
      prevExp = lastExp;
      lastExp = lastExp.simplify();
    }

    return lastExp;
  }
}
