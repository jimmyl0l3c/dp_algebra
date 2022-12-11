class EquationException implements Exception {
  String errMessage() => 'EquationException';
}

class EqNotSolvableByCramerException implements EquationException {
  @override
  String errMessage() => 'Determinant matice rovnice nesmí být roven nula';
}

class EquationsNotSolvableException implements EquationException {
  @override
  String errMessage() => 'Soustava rovnic není řešitelná';
}
