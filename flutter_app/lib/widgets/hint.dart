import 'package:flutter/material.dart';

class Hint extends StatelessWidget {
  final List<InlineSpan>? richMessage;
  final String? message;

  const Hint({Key? key, this.message, this.richMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: richMessage == null ? message : null,
      richMessage: richMessage != null
          ? TextSpan(
              children: richMessage,
            )
          : null,
      triggerMode: TooltipTriggerMode.tap,
      child: const Icon(
        Icons.help,
        size: 18.0,
        color: Colors.blueGrey,
      ),
    );
  }
}
