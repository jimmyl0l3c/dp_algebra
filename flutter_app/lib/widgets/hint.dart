import 'package:flutter/material.dart';

class Hint extends StatelessWidget {
  final String message;

  const Hint(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: const Icon(
        Icons.help,
        size: 18.0,
        color: Colors.blueGrey,
      ),
    );
  }
}
