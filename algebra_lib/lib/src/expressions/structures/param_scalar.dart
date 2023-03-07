import 'package:algebra_lib/algebra_lib.dart';

class ParametrizedScalar implements Expression {
  final Expression n;
  final int param;

  ParametrizedScalar({required this.n, required this.param});

  @override
  Expression simplify() {
    if (n is Vector || n is Matrix || n is ParametrizedScalar) {
      throw UndefinedOperationException();
    }

    if (n is! Scalar) {
      return ParametrizedScalar(n: n.simplify(), param: param);
    }

    return this;
  }

  @override
  String toTeX() {
    StringBuffer buffer = StringBuffer();
    if (n != Scalar.one()) {
      buffer.write(n.toTeX());
    }
    buffer.write('x_{$param}');
    return buffer.toString();
  }
}
