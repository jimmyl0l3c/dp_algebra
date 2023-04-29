import 'package:algebra_lib/algebra_lib.dart';

import '../../main.dart';
import 'calc_expression_exception.dart';

class CalcResult {
  final Expression calculation;
  final Expression result;
  final List<Expression> steps;

  CalcResult({
    required this.calculation,
    required this.result,
    required this.steps,
  });

  factory CalcResult.calculate(Expression calculation) {
    try {
      var steps = _getCalculationSteps(calculation);

      return CalcResult(
        calculation: calculation,
        result: steps.last,
        steps: steps,
      );
    } on ExpressionException catch (e) {
      throw CalcExpressionException.fromExpressionException(calculation, e);
    } on Exception catch (e) {
      // Catch all exceptions, hopefully prevent freezing of the app
      logger.e(e.toString());
      throw CalcExpressionException(
        friendlyMessage: 'Exception occurred while calculating expression',
        cause: e,
      );
    } on Error catch (e) {
      logger.e(e.toString());
      throw CalcExpressionException(
        friendlyMessage: 'Exception occurred while calculating expression',
        cause: e,
      );
    }
  }

  static List<Expression> _getCalculationSteps(Expression calculation) {
    List<Expression> output = [];

    Expression prevExp = calculation;
    Expression lastExp = calculation;

    do {
      output.add(lastExp);
      prevExp = lastExp;
      lastExp = lastExp.simplify();
    } while (prevExp != lastExp);

    return output;
  }
}
