import 'package:algebra_lib/src/expressions/scalar.dart';
import 'package:algebra_lib/src/interfaces/expression.dart';

class Multiply implements Expression {
  final Expression left;
  final Expression right;

  Multiply({required this.left, required this.right});

  @override
  Expression simplify() {
    if (left is! Scalar) {
      return Multiply(left: left.simplify(), right: right);
    }

    if (right is! Scalar) {
      return Multiply(left: left, right: right.simplify());
    }

    return Scalar(value: (left as Scalar).value * (right as Scalar).value);
  }

  @override
  String toTeX() => '${left.toTeX()} \\cdot ${right.toTeX()}';
}
