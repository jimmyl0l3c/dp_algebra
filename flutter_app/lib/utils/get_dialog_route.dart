import 'package:flutter/material.dart';

Route<String> getDialogRoute(
  BuildContext context,
  String title,
  Widget content,
) {
  final theme = Theme.of(context);

  return DialogRoute<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Zavřít',
              style: TextStyle(color: theme.colorScheme.secondary),
            ),
          ),
        ],
      );
    },
  );
}
