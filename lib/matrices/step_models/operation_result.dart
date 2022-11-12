import 'package:fraction/fraction.dart';

import '../matrix.dart';
import 'matrix_entry.dart';

class OperationResult {}

class ScalarResult extends OperationResult {
  Fraction value;

  ScalarResult({required this.value});
}

class EntryResult extends ScalarResult {
  MatrixEntry entry;

  EntryResult({required value, required this.entry}) : super(value: value);
}

class MatrixResult extends OperationResult {
  Matrix value;

  MatrixResult({required this.value});
}
