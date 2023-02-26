class BinMatrixStep {
  final int rowA, colA;
  final int rowB, colB;
  final int rowC, colC;
  final String calculation;
  List<BinMatrixStep>? subSteps;

  BinMatrixStep({
    required this.rowA,
    required this.colA,
    required this.rowB,
    required this.colB,
    required this.rowC,
    required this.colC,
    required this.calculation,
    this.subSteps,
  });
}
