import 'package:algebra_lib/algebra_lib.dart';
import 'package:fraction/fraction.dart';

class ScalarProvider {
  static final Map<int, Scalar> _scalars = {};

  static Scalar get(int scalar) {
    if (!_scalars.containsKey(scalar)) {
      _scalars[scalar] = Scalar(value: Fraction(scalar));
    }

    return _scalars[scalar]!;
  }
}
