import 'package:fraction/fraction.dart';

class PreciseFraction {
  final BigInt _numerator;
  final BigInt _denominator;

  const PreciseFraction._(this._numerator, this._denominator);

  factory PreciseFraction(BigInt numerator, [BigInt? denominator]) {
    denominator ??= BigInt.one;

    if (denominator == BigInt.zero) {
      throw UnsupportedError("Division by zero");
    }

    if (denominator < BigInt.zero) {
      return PreciseFraction._(
        numerator * BigInt.from(-1),
        denominator * BigInt.from(-1),
      );
    } else {
      return PreciseFraction._(numerator, denominator);
    }
  }

  // TODO: support proper conversion from double
  PreciseFraction.from(num numerator, [num denominator = 1])
      : _numerator = BigInt.from(numerator),
        _denominator = BigInt.from(denominator);

  PreciseFraction.zero()
      : _numerator = BigInt.zero,
        _denominator = BigInt.one;

  PreciseFraction.one()
      : _numerator = BigInt.one,
        _denominator = BigInt.one;

  PreciseFraction.minusOne()
      : _numerator = BigInt.from(-1),
        _denominator = BigInt.one;

  BigInt get numerator => _numerator;

  BigInt get denominator => _denominator;

  bool get isNegative => numerator < BigInt.zero;

  bool get isWhole => denominator == BigInt.one;

  @override
  bool operator ==(Object other) {
    // Two fractions are equal if their "cross product" is equal.
    //
    // ```dart
    // final one = Fraction(1, 2);
    // final two = Fraction(2, 4);
    //
    // final areEqual = (one == two); //true
    // ```
    //
    // The above example returns true because the "cross product" of `one` and
    // two` is equal (1*4 = 2*2).
    if (identical(this, other)) {
      return true;
    }

    if (other is PreciseFraction) {
      final fraction = other;

      return runtimeType == fraction.runtimeType &&
          (numerator * fraction.denominator ==
              denominator * fraction.numerator);
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;

    result = result * 37 + numerator.hashCode;
    result = result * 37 + denominator.hashCode;

    return result;
  }

  @override
  String toString() {
    if (denominator == BigInt.one) {
      return '$numerator';
    }

    return '$numerator/$denominator';
  }

  PreciseFraction negate() =>
      PreciseFraction(numerator * BigInt.from(-1), denominator);

  PreciseFraction reduce() {
    // Storing the sign for later use.
    final sign = (numerator < BigInt.zero) ? BigInt.from(-1) : BigInt.one;

    // Calculating the gcd for reduction.
    final lgcd = numerator.gcd(denominator);

    final num = (numerator * sign) ~/ lgcd;
    final den = (denominator * sign) ~/ lgcd;

    return PreciseFraction(num, den);
  }

  PreciseFraction inverse() => PreciseFraction(denominator, numerator);

  /// The sum between two fractions.
  PreciseFraction operator +(PreciseFraction other) => PreciseFraction(
        numerator * other.denominator + denominator * other.numerator,
        denominator * other.denominator,
      );

  /// The difference between two fractions.
  PreciseFraction operator -(PreciseFraction other) => PreciseFraction(
        numerator * other.denominator - denominator * other.numerator,
        denominator * other.denominator,
      );

  /// The product of two fractions.
  PreciseFraction operator *(PreciseFraction other) => PreciseFraction(
        numerator * other.numerator,
        denominator * other.denominator,
      );

  /// The division of two fractions.
  PreciseFraction operator /(PreciseFraction other) => PreciseFraction(
        numerator * other.denominator,
        denominator * other.numerator,
      );

  Fraction toFraction() => Fraction(numerator.toInt(), denominator.toInt());
}
