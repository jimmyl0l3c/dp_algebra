import 'package:algebra_lib/algebra_lib.dart';
import 'package:fraction/fraction.dart';

class Scalar implements Expression {
  final Fraction value;

  Scalar({required this.value});

  @override
  Expression simplify() => this;

  @override
  String toTeX() => value.reduce().toString();
}
