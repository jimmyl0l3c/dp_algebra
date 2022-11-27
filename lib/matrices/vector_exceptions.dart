class VectorException implements Exception {
  String errMessage() => 'VectorException';
}

class VectorSizeMismatchException implements VectorException {
  @override
  String errMessage() => 'Vektory musí mít stejnou velikost';
}
