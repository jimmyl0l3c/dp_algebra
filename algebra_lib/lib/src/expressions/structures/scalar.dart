import 'package:algebra_lib/algebra_lib.dart';
import 'package:fraction/fraction.dart';

class Scalar implements Expression {
  final Fraction value;

  Scalar({required this.value});

  Scalar.zero() : value = Fraction(0);
  Scalar.one() : value = Fraction(1);

  @override
  Expression simplify() => this;

  // TODO: add toTeX() extension to Fraction
  @override
  String toTeX() => value.reduce().toString();

  @override
  String toString() => value.reduce().toString();

  @override
  bool operator ==(Object other) {
    if (other is Scalar) {
      return value == other.value;
    }

    return false;
  }

  @override
  int get hashCode => value.hashCode;
}
