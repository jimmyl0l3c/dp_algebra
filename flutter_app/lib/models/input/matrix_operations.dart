enum BinaryMatrixOperation {
  add('+'),
  diff('-'),
  multiply('*');

  final String symbol;

  const BinaryMatrixOperation(this.symbol);

  @override
  String toString() => symbol;
}

enum UnaryMatrixOperation {
  det('Determinant'),
  rank('Hodnost'),
  inverse('Inverzní matice'),
  transpose('Transponovaná matice'),
  triangular('Trojúhelníková matice'),
  reduce('Redukovaná matice');

  final String description;

  const UnaryMatrixOperation(this.description);

  @override
  String toString() => description;
}
