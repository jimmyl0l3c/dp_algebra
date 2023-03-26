import 'package:flutter/material.dart';

Widget decorateVectorInput(Widget child, int i, int length) {
  const double padding = 6.0;
  const double scaleX = 1.2;
  const double scaleY = 3.0;

  if (i == 0 || i == (length - 1)) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (i == 0 || length == 1)
          Transform.scale(
            scaleY: scaleY,
            scaleX: scaleX,
            origin: Offset.fromDirection(90, 1),
            child: const Text(
              '(',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(
            left: i == 0 ? padding : 0.0,
            right: i == (length - 1) ? padding : 0.0,
          ),
          child: child,
        ),
        if (i == (length - 1))
          Transform.scale(
            scaleY: scaleY,
            scaleX: scaleX,
            origin: Offset.fromDirection(90, 1),
            child: const Text(
              ')',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
  return child;
}
