import 'package:algebra_lib/algebra_lib.dart';

class Divide implements Expression {
  Expression numerator;
  Expression denominator;

  Divide({required this.numerator, required this.denominator}) {
    if (numerator is Matrix || numerator is Vector) {
      throw UndefinedOperationException();
    }

    if (denominator is Matrix || denominator is Vector) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (numerator is Matrix || numerator is Vector) {
      throw UndefinedOperationException();
    }

    if (denominator is Matrix || denominator is Vector) {
      throw UndefinedOperationException();
    }

    if (numerator is! Scalar) {
      return Divide(numerator: numerator.simplify(), denominator: denominator);
    }

    if (denominator is! Scalar) {
      return Divide(numerator: numerator, denominator: denominator.simplify());
    }

    return Scalar(
      value: (numerator as Scalar).value / (denominator as Scalar).value,
    );
  }

  @override
  String toTeX() => '\\frac{${numerator.toTeX()}}{${denominator.toTeX()}}';
}
