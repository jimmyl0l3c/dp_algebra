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
