import 'package:flutter/material.dart';

class InTextButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const InTextButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      style: const ButtonStyle(
        // Infinite is ignored
        fixedSize: WidgetStatePropertyAll(Size.infinite),
        // Disable minimum size and padding
        minimumSize: WidgetStatePropertyAll(Size.zero),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
