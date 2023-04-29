import 'package:algebra_lib/algebra_lib.dart';

class CalcExpressionException implements Exception {
  final String friendlyMessage;
  final dynamic cause;

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
      message = 'Matice musí mít stejné rozměry';
    } else if (exception is VectorSizeMismatchException) {
      message = 'Vektory musí mít stejnou velikost';
    } else if (exception is MatrixMultiplySizeException) {
      message = 'Počet sloupců první matice musí být roven počtu řádků druhé';
    } else if (exception is DeterminantNotSquareException) {
      message = 'Matice musí být čtvercová';
    } else if (exception is VectorsNotIndependentException) {
      message = 'Vektory musí být lineárně nezávislé';
    } else if (exception is BasisSizeMismatchException) {
      message = 'Počet vektorů generujících obě báze musí být stejný';
    } else if (exception is EquationsNotSolvableException) {
      message = 'Soustava rovnic není řešitelná';
    }

    if (exception is DivisionByZeroException) {
      if (calculation is Inverse) {
        message = 'Inverzní matice k zadané matici neexistuje';
      } else if (calculation is SolveWithCramer ||
          calculation is SolveWithInverse) {
        message = 'Determinant matice rovnice nesmí být roven nule';
      } else {
        message = 'Nelze dělit nulou';
      }
    }

    return CalcExpressionException(
      friendlyMessage: message,
      cause: exception,
    );
  }
}
