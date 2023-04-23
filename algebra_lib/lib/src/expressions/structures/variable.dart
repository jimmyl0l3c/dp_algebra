import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';
import 'matrix.dart';

class Variable implements Expression {
  final Expression n;
  final int param;

  Variable({required this.n, required this.param});

  @override
  Expression simplify() {
    if (n is Vector || n is Matrix || n is Variable) {
      throw UndefinedOperationException();
    }

    if (n is! Scalar) {
      return Variable(n: n.simplify(), param: param);
    }

    return this;
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    StringBuffer buffer = StringBuffer();
    if (n != Scalar.one()) {
      buffer.write(n.toTeX());
    }
    buffer.write('x_{$param}');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (other is! Variable) return false;
    return other.param == param && other.n == n;
  }

  @override
  int get hashCode => Object.hash(n, param);
}
