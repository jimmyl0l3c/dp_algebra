import 'package:fraction/fraction.dart';

import '../matrix.dart';
import 'matrix_entry.dart';
import 'operation_result.dart';

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
