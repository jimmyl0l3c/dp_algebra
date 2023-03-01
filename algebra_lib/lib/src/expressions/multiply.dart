import 'package:algebra_lib/algebra_lib.dart';
import 'package:algebra_lib/src/expressions/addition.dart';

class Multiply implements Expression {
  final Expression left;
  final Expression right;

  Multiply({required this.left, required this.right});

  @override
  Expression simplify() {
    // If left can be simplified, do it
    if (left is! Vector && left is! Matrix && left is! Scalar) {
      return Multiply(left: left.simplify(), right: right);
    }

    // If right can be simplified, do it
    if (right is! Vector && right is! Matrix && right is! Scalar) {
      return Multiply(left: left, right: right.simplify());
    }

    if (left is Scalar && right is Scalar) {
      return Scalar(value: (left as Scalar).value * (right as Scalar).value);
    }

    if (left is Scalar && right is Vector) {
      List<Expression> multipliedVector = [];

      for (var item in (right as Vector).items) {
        multipliedVector.add(Multiply(left: left, right: item));
      }

      return Vector(items: multipliedVector);
    }

    if (left is Scalar && right is Matrix) {
      List<List<Expression>> multipliedMatrix = [];

      for (var row in (right as Matrix).items) {
        List<Expression> multipliedRow = [];

        for (var col in row) {
          multipliedRow.add(Multiply(left: left, right: col));
        }

        multipliedMatrix.add(multipliedRow);
      }

      return Matrix(items: multipliedMatrix);
    }

    if (left is Matrix && right is Matrix) {
      Matrix leftMatrix = left as Matrix;
      Matrix rightMatrix = right as Matrix;

      int leftCols = leftMatrix.columns();
      int rightRows = rightMatrix.rows();

      if (leftCols != rightRows) throw MatrixMultiplySizeException();

      int leftRows = leftMatrix.rows();
      int rightCols = rightMatrix.columns();

      if (leftRows == 1 && rightCols == 1) {
        Expression item = Multiply(
          left: leftMatrix.items.first.first,
          right: rightMatrix.items.first.first,
        );

        for (var i = 1; i < leftCols; i++) {
          item = Addition(
            left: item,
            right: Multiply(
              left: leftMatrix.items.first[i],
              right: rightMatrix.items[i].first,
            ),
          );
        }

        return item;
      } else {
        List<List<Expression>> multipliedMatrices = [];

        for (var ra = 0; ra < leftRows; ra++) {
          List<Expression> outputRow = [];
          for (var cb = 0; cb < rightCols; cb++) {
            outputRow.add(
              Multiply(
                left: Matrix(
                  items: [leftMatrix.items[ra]],
                ),
                right: Matrix(
                  items: rightMatrix.items.map((row) => [row[cb]]).toList(),
                ),
              ),
            );
          }
          multipliedMatrices.add(outputRow);
        }

        return Matrix(items: multipliedMatrices);
      }
    }

    throw UndefinedOperationException();
  }

  @override
  String toTeX() => '${left.toTeX()} \\cdot ${right.toTeX()}';
}
