import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/models/calc_expression_exception.dart';

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
      var steps = CalcResult._getCalculationSteps(calculation);

      return CalcResult(
        calculation: calculation,
        result: steps.last,
        steps: steps,
      );
    } on ExpressionException catch (e) {
      String message = e.runtimeType.toString();

      if (e is MatrixSizeMismatchException) {
        message = "Matice musí mít stejné rozměry";
      } else if (e is VectorSizeMismatchException) {
        message = "Vektory musí mít stejnou velikost";
      } else if (e is MatrixMultiplySizeException) {
        message = "Počet sloupců první matice musí být roven počtu řádků druhé";
      } else if (e is DeterminantNotSquareException) {
        message = "Matice musí být čtvercová";
      }

      if (e is DivisionByZeroException) {
        if (calculation is Inverse) {
          message = "Inverzní matice k zadané matici neexistuje";
        } else if (calculation is SolveWithCramer ||
            calculation is SolveWithInverse) {
          message = "Determinant matice rovnice nesmí být roven nule";
        } else {
          message = "Nelze dělit nulou";
        }
      }

      throw CalcExpressionException(
        friendlyMessage: message,
        cause: e,
      );
    }
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
