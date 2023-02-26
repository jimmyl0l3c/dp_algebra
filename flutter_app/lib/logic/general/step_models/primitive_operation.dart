import 'package:dp_algebra/logic/general/step_models/matrix_entry.dart';
import 'package:dp_algebra/logic/general/step_models/operation_result.dart';
import 'package:dp_algebra/logic/matrix/matrix.dart';
import 'package:fraction/fraction.dart';

class PrimitiveOperation {}

class PrimitiveScalarOperation extends PrimitiveOperation {
  Fraction scalarA;
  Fraction scalarB;
  ScalarResult result;

  PrimitiveScalarOperation({
    required this.scalarA,
    required this.scalarB,
    required this.result,
  });
}

class PrimitiveMatrixOperation extends PrimitiveOperation {
  Matrix matrixA;
  Matrix? matrixB;
  String operation;
  OperationResult result;

  PrimitiveMatrixOperation({
    required this.matrixA,
    this.matrixB,
    required this.operation,
    required this.result,
  });
}

class EntryByScalarOperation extends PrimitiveMatrixOperation {
  MatrixEntry entry;
  Fraction n;

  EntryByScalarOperation({
    required matrixA,
    matrixB,
    required operation,
    required result,
    required this.entry,
    required this.n,
  }) : super(
          matrixA: matrixA,
          matrixB: matrixB,
          operation: operation,
          result: result,
        );
}

class EntryByEntryOperation extends PrimitiveMatrixOperation {
  MatrixEntry entryA;
  MatrixEntry entryB;

  EntryByEntryOperation({
    required matrixA,
    matrixB,
    required operation,
    required result,
    required this.entryA,
    required this.entryB,
  }) : super(
          matrixA: matrixA,
          matrixB: matrixB,
          operation: operation,
          result: result,
        );
}

class RowByRowOperation extends PrimitiveMatrixOperation {
  int rowA;
  int rowB;

  RowByRowOperation({
    required matrixA,
    matrixB,
    required operation,
    required result,
    required this.rowA,
    required this.rowB,
  }) : super(
          matrixA: matrixA,
          matrixB: matrixB,
          operation: operation,
          result: result,
        );
}

class RowByNRowOperation extends RowByRowOperation {
  Fraction n;

  RowByNRowOperation({
    required matrixA,
    matrixB,
    required operation,
    required result,
    required rowA,
    required rowB,
    required this.n,
  }) : super(
          matrixA: matrixA,
          matrixB: matrixB,
          operation: operation,
          result: result,
          rowA: rowA,
          rowB: rowB,
        );
}