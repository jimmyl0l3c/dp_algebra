import 'package:algebra_lib/algebra_lib.dart';

class CalcExpressionException implements Exception {
  final String friendlyMessage;
  final Exception? cause;

  CalcExpressionException({
    required this.friendlyMessage,
    required this.cause,
  });

  factory CalcExpressionException.fromExpressionException(
    Expression? calculation,
    Exception exception,
  ) {
    String message = exception.runtimeType.toString();

    if (exception is MatrixSizeMismatchException) {
      message = "Matice musí mít stejné rozměry";
    } else if (exception is VectorSizeMismatchException) {
      message = "Vektory musí mít stejnou velikost";
    } else if (exception is MatrixMultiplySizeException) {
      message = "Počet sloupců první matice musí být roven počtu řádků druhé";
    } else if (exception is DeterminantNotSquareException) {
      message = "Matice musí být čtvercová";
    }

    if (exception is DivisionByZeroException) {
      if (calculation is Inverse) {
        message = "Inverzní matice k zadané matici neexistuje";
      } else if (calculation is SolveWithCramer ||
          calculation is SolveWithInverse) {
        message = "Determinant matice rovnice nesmí být roven nule";
      } else {
        message = "Nelze dělit nulou";
      }
    }

    // TODO: handle new exceptions (basis size mismatch, ...)

    return CalcExpressionException(
      friendlyMessage: message,
      cause: exception,
    );
  }
}
