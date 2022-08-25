import 'package:dp_algebra/matrices/extensions.dart';
import 'package:fraction/fraction.dart';

import 'matrix.dart';
import 'matrix_operations.dart';

class Solution {
  final dynamic leftOp;
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

  String _matrixOrFractionToTex(dynamic x) {
    if (x is Matrix) {
      return x.toTeX(
        isDeterminant: operation == MatrixOperation.det,
      );
    } else if (x is Fraction) {
      return x.toTeX();
    } else {
      return x.toString();
    }
  }

  String toTeX() {
    StringBuffer buffer = StringBuffer();

    if (operation.prependSymbol) buffer.write(operation.symbol);

    if (operation.enclose) buffer.write('(');
    buffer.write(_matrixOrFractionToTex(leftOp));
    if (operation.enclose) buffer.write(')');

    if (!operation.prependSymbol) buffer.write(operation.symbol);

    if (rightOp != null) buffer.write(rightOp!.toTeX());

    buffer.write('=');
    buffer.write(_matrixOrFractionToTex(solution));

    return buffer.toString();
  }
}
