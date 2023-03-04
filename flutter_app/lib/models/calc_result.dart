import 'package:algebra_lib/algebra_lib.dart';

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
    var steps = CalcResult._getCalculationSteps(calculation);

    return CalcResult(
      calculation: calculation,
      result: steps.last,
      steps: steps,
    );
  }

  static List<Expression> _getCalculationSteps(Expression calculation) {
    List<Expression> output = [calculation];

    Expression prevExp = calculation;
    Expression lastExp = calculation.simplify();

    while (prevExp != lastExp) {
      output.add(lastExp);
      prevExp = lastExp;
      lastExp = lastExp.simplify();
    }

    return output;
  }
}
