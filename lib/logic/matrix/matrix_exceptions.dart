class MatrixException implements Exception {
  String errMessage() => 'MatrixException';
}

class MatrixSizeMismatchException implements MatrixException {
  @override
  String errMessage() => 'Matice musí mít stejnou velikost';
}

class MatrixMultiplySizeException implements MatrixException {
  @override
  String errMessage() =>
      'Počet sloupců první matice musí být roven počtu řádků druhé';
}

class MatrixIsNotSquareException implements MatrixException {
  @override
  String errMessage() => 'Matice musí být čtvercová';
}

class MatrixInverseImpossibleException implements MatrixException {
  @override
  String errMessage() => 'Inverzní matice k zadané matici neexistuje';
}

class MatrixOutOfBoundsException implements MatrixException {
  @override
  String errMessage() => 'MatrixOutOfBoundsException';
}

class InvalidTypeException implements MatrixException {
  @override
  String errMessage() => 'InvalidTypeException';
}
