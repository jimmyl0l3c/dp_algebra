import 'package:dp_algebra/logic/general/tex_parsable.dart';
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

class MatrixAtomicUnaryOperation extends TexParsable {}

class ExchangeRowsOp extends MatrixAtomicUnaryOperation {
  final int row1;
  final int row2;

  ExchangeRowsOp({
    required this.row1,
    required this.row2,
  });

  @override
  String toTeX() => 'Zaměníme ${row1 + 1}. a ${row2 + 1}. řádek';
}

class MultiplyRowOp extends MatrixAtomicUnaryOperation {
  final int row;
  final Fraction n;

  MultiplyRowOp({
    required this.row,
    required this.n,
  });

  @override
  String toTeX() => '${row + 1}. řádek vynásobíme $n';
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

  @override
  String toTeX() {
    if (n == 1.toFraction()) {
      return 'K ${row1 + 1}. řádku přičteme ${row2 + 1}.';
    }
    return 'K ${row1 + 1}. řádku přičteme $n násobek ${row2 + 1}. řádku';
  }
}
