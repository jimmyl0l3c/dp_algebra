enum MatrixOperation {
  add(
    description: 'Součet',
    symbol: '+',
    binary: true,
  ),
  diff(
    description: 'Rozdíl',
    symbol: '-',
    binary: true,
  ),
  multiply(
    description: 'Součin',
    symbol: '*',
    binary: true,
  ),
  det(
    description: 'Determinant',
    symbol: 'det',
    prependSymbol: true,
    binary: false,
  ),
  rank(
    description: 'Hodnost',
    symbol: 'h',
    prependSymbol: true,
    enclose: true,
    binary: false,
  );

  final String description;
  final String symbol;
  final bool prependSymbol;
  final bool enclose;
  final bool binary;

  const MatrixOperation({
    required this.description,
    required this.symbol,
    this.prependSymbol = false,
    this.enclose = false,
    required this.binary,
  });
}
