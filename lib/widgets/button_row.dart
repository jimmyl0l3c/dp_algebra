import 'package:flutter/material.dart';

class ButtonRowItem {
  final Widget child;
  final void Function()? onPressed;

  ButtonRowItem({required this.child, this.onPressed});
}

class ButtonRow extends StatelessWidget {
  final List<ButtonRowItem> children;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const ButtonRow({
    Key? key,
    required this.children,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
                            color: Colors.deepPurple.shade800,
                            width: 2.0,
                          ),
                        ))
                      : null,
                  child: TextButton(
                    onPressed: children[i].onPressed,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(padding ??
                          const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 8,
                          )),
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.white12;
                        }
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.deepPurpleAccent[100];
                        }
                        if (states.contains(MaterialState.hovered) ||
                            states.contains(MaterialState.focused)) {
                          return Colors.deepPurpleAccent;
                        }
                        return Theme.of(context).colorScheme.primary;
                      }),
                      foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                      side: MaterialStateProperty.all(BorderSide.none),
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder()),
                    ),
                    child: children[i].child,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
