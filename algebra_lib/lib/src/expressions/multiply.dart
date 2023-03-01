import 'package:algebra_lib/algebra_lib.dart';
import 'package:algebra_lib/src/expressions/matrix.dart';

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
      // TODO: implement
    }

    throw UndefinedOperationException();
  }

  @override
  String toTeX() => '${left.toTeX()} \\cdot ${right.toTeX()}';
}
