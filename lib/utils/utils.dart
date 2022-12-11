import 'package:flutter/material.dart';

class AlgebraUtils {
  // TODO: add state option (error, correct, info)
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
