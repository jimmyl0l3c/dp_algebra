class VectorException implements Exception {
  String errMessage() => 'VectorException';
}

class VectorSizeMismatchException implements VectorException {
  @override
  String errMessage() => 'Vektory musí mít stejnou velikost';
}

class VectorsLinearlyDependentException implements VectorException {
  @override
  String errMessage() => 'Vektory musí být lineárně nezávislé';
}

class VectorTransformMatrixNotSquareException implements VectorException {
  @override
  String errMessage() => 'Matice přechodu musí být čtvercová';
}

class VectorTransformMatrixSizeMismatchException implements VectorException {
  @override
  String errMessage() =>
      'Vektor souřadnic musí mít stejnou velikost jako matice přechodu';
}
