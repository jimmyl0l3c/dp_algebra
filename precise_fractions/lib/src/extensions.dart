import 'package:fraction/fraction.dart';
import 'package:precise_fractions/precise_fractions.dart';

extension FractionToPreciseFraction on Fraction {
  PreciseFraction toPreciseFrac() =>
      PreciseFraction(BigInt.from(numerator), BigInt.from(denominator));
}
