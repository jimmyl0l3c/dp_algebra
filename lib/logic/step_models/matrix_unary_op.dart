import 'package:dp_algebra/logic/matrix/matrix.dart';
import 'package:dp_algebra/logic/matrix/matrix_operations.dart';
import 'package:dp_algebra/logic/step_models/general_op.dart';
import 'package:fraction/fraction.dart';

class MatrixUnaryOperation extends CalcStep {
  final Matrix matrix;
  final List<MatrixAtomicUnaryOperation> operations;

  MatrixUnaryOperation({
    required MatrixOperation type,
    required this.matrix,
    required this.operations,
  }) : super(type: type);
}

class MatrixAtomicUnaryOperation {}

class ExchangeRowsOp extends MatrixAtomicUnaryOperation {
  final int row1;
  final int row2;

  ExchangeRowsOp({
    required this.row1,
    required this.row2,
  });
}

class MultiplyRowOp extends MatrixAtomicUnaryOperation {
  final int row;
  final Fraction n;

  MultiplyRowOp({
    required this.row,
    required this.n,
  });
}

class AddRowToRowNTimesOp extends MatrixAtomicUnaryOperation {
  final int row1;
  final int row2;
  final Fraction n;

  AddRowToRowNTimesOp({
    required this.row1,
    required this.row2,
    required this.n,
  });
}
