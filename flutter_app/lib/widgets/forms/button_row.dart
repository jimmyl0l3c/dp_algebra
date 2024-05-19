import 'package:flutter/material.dart';

class ButtonRowItem {
  final String? tooltip;
  final void Function()? onPressed;
  final Widget child;

  ButtonRowItem({this.tooltip, this.onPressed, required this.child});
}

class ButtonRow extends StatelessWidget {
  final List<ButtonRowItem> children;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const ButtonRow({
    super.key,
    required this.children,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children
                .asMap()
                .keys
                .toList()
                .map(
                  (i) => Container(
                    decoration: i != (children.length - 1)
                        ? BoxDecoration(
                            border: Border(
                            right: BorderSide(
                              color: children[i].onPressed == null
                                  ? Colors.black12
                                  : Colors.deepPurple.shade800,
                              width: 2.0,
                            ),
                          ))
                        : null,
                    child: children[i].tooltip != null
                        ? Tooltip(
                            message: children[i].tooltip,
                            child: _getRowButton(context, children[i]),
                          )
                        : _getRowButton(context, children[i]),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _getRowButton(BuildContext context, ButtonRowItem item) => TextButton(
        onPressed: item.onPressed,
        style: ButtonStyle(
          padding: WidgetStateProperty.all(padding ??
              const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 8,
              )),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.white12;
            }
            if (states.contains(WidgetState.pressed)) {
              return Colors.deepPurpleAccent[100];
            }
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return Colors.deepPurpleAccent;
            }
            return Theme.of(context).colorScheme.primary;
          }),
          foregroundColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.onPrimary,
          ),
          side: WidgetStateProperty.all(BorderSide.none),
          shape: WidgetStateProperty.all(const RoundedRectangleBorder()),
        ),
        child: item.child,
      );
}
