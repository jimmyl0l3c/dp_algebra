import 'package:algebra_lib/algebra_lib.dart';
import 'package:precise_fractions/precise_fractions.dart';

class Scalar implements Expression {
  final PreciseFraction value;

  Scalar({required this.value});

  Scalar.zero() : value = PreciseFraction.zero();
  Scalar.one() : value = PreciseFraction.one();

  @override
  Expression simplify() => this;

  // TODO: add toTeX() extension to Fraction
  @override
  String toTeX({Set<TexFlags>? flags}) => value.reduce().toString();

  @override
  String toString() => value.reduce().toString();

  @override
  bool operator ==(Object other) {
    if (other is! Scalar) return false;
    return value == other.value;
  }

  @override
  int get hashCode => value.hashCode;
}
