import 'package:dp_algebra/logic/matrix/matrix.dart';
import 'package:dp_algebra/logic/matrix/matrix_operations.dart';
import 'package:dp_algebra/logic/step_models/general_op.dart';

class MatrixBinaryOperation extends CalcStep {
  final dynamic leftOperand;
  final Matrix matrix;
  final List<MatrixAtomicBinaryOperation> operations;

  MatrixBinaryOperation({
    required MatrixOperation type,
    required this.leftOperand,
    required this.matrix,
    required this.operations,
  }) : super(type: type);

  @override
  int getInnerStepLength() => operations.length;
}

class MatrixAtomicBinaryOperation {
  final int row1;
  final int col1;
  final String operation; // TODO: use enum

  MatrixAtomicBinaryOperation({
    required this.row1,
    required this.col1,
    required this.operation,
  });
}

class EntryToEntryOperation extends MatrixAtomicBinaryOperation {
  final int row2;
  final int col2;

  EntryToEntryOperation({
    required row1,
    required col1,
    required operation,
    required this.row2,
    required this.col2,
  }) : super(row1: row1, col1: col1, operation: operation);
}
