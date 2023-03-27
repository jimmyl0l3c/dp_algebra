import 'package:big_fraction/big_fraction.dart';
import 'package:flutter/material.dart';

// TODO: add state option (error, correct, info)
void showSnackBarMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

BigFraction? parseFraction(String value) {
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
    return dValue.toBigFraction() * sign.toBigFraction();
  } else {
    if (value.startsWith('/')) value = '0$value';
    if (!value.isBigFraction) return null;
    return value.toBigFraction() * sign.toBigFraction();
  }
}
