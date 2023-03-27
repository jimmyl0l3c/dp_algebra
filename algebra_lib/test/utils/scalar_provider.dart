import 'package:algebra_lib/algebra_lib.dart';
import 'package:precise_fractions/precise_fractions.dart';

class ScalarProvider {
  static final Map<int, Scalar> _scalars = {};

  static Scalar get(int scalar) {
    if (!_scalars.containsKey(scalar)) {
      _scalars[scalar] = Scalar(value: PreciseFraction.from(scalar));
    }

    return _scalars[scalar]!;
  }
}
