enum PredefinedRef {
  transposedMatrix("def:transposed"),
  matrixAddition("def:matrix-addition"),
  matrixMultiplication("def:matrix-multiplication"),
  multiplyMatrixByScalar("def:multiply-m-by-scalar"),
  determinant("def:determinant"),
  inverseMatrix("def:inverse-matrix"),
  vectorLinIndependence("def:vector-lin-independence"),
  matrixRank("def:matrix-rank"),
  basis("def:basis"),
  gaussianElimination("theorem:gauss"),
  solveSystemByInverse("consequence:inverse-solved-system"),
  cramerTheorem("theorem:cramer"),
  transformMatrix("def:transform-matrix"),
  transformCoords("theorem:transform-coords");

  final String refName;

  const PredefinedRef(this.refName);
}
