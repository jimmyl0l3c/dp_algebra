import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class AlgebraUtils {
  // TODO: add state option (error, correct, info)
  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  static Fraction? parseFraction(String value) {
    int sign = 1;
    if (value.startsWith(RegExp(r'[+-]'))) {
      sign = value[0] == '-' ? -1 : 1;
      value = value.substring(1);

      if (value.contains(RegExp(r'[+-]'))) return null;
    }

    if (value.isEmpty) {
      return null;
    } else if (value.contains('.')) {
      double? dValue = double.tryParse(value);
      if (dValue == null) {
        return null;
      }
      return dValue.toFraction() * sign.toFraction();
    } else {
      if (value.startsWith('/')) value = '0$value';
      if (!value.isFraction) return null;
      return value.toFraction() * sign.toFraction();
    }
  }
}
