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
  inverse('Inverzní matice'),
  transpose('Transponovaná matice'),
  rank('Hodnost');

  final String description;

  const UnaryMatrixOperation(this.description);

  @override
  String toString() => description;
}
