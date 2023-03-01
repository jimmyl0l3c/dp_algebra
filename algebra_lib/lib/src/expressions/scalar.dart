import 'package:algebra_lib/src/interfaces/expression.dart';
import 'package:fraction/fraction.dart';

class Scalar implements Expression {
  final Fraction value;

  Scalar({required this.value});

  @override
  Expression simplify() => this;

  @override
  String toTeX() => value.reduce().toString();
}
