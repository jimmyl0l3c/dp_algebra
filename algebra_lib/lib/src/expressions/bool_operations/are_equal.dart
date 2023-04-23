import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/boolean.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';

class AreEqual implements Expression {
  final Expression left;
  final Expression right;

  AreEqual({required this.left, required this.right});

  @override
  Expression simplify() {
    if (left is! Vector && left is! Matrix && left is! Scalar) {
      return AreEqual(left: left.simplify(), right: right);
    }

    if (right is! Vector && right is! Matrix && right is! Scalar) {
      return AreEqual(left: left, right: right.simplify());
    }

    return Boolean(left == right);
  }

  @override
  String toTeX({Set<TexFlags>? flags}) => '${left.toTeX()} == ${right.toTeX()}';
}
