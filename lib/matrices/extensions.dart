import 'package:fraction/fraction.dart';

extension ParsingToTex on Fraction {
  String toTeX() {
    if (isWhole) {
      return toString();
    } else {
      return '\\frac{$numerator}{$denominator}';
    }
  }
}
