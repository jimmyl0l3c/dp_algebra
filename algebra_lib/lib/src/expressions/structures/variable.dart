import 'package:algebra_lib/algebra_lib.dart';

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
}
