import 'matrix.dart';
import 'matrix_operations.dart';

class Solution {
  final Matrix leftOp;
  final Matrix? rightOp;
  final MatrixOperation operation;
  final dynamic solution;
  final Object? stepByStep;

  Solution({
    required this.leftOp,
    this.rightOp,
    required this.operation,
    required this.solution,
    this.stepByStep,
  });
}
