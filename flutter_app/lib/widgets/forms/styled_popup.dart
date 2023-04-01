import 'package:flutter/material.dart';

class StyledPopupButton<T> extends StatelessWidget {
  final void Function(T)? onSelected;
  final String? child;
  final String? placeholder;
  final List<PopupMenuEntry<T>> Function(BuildContext) itemBuilder;
  final AlignmentGeometry? valueAlignment;
  final double? maxWidth;
  final bool? isExpanded;
  final String? tooltip;

  const StyledPopupButton(
      {Key? key,
      this.onSelected,
      this.child,
      this.placeholder,
      required this.itemBuilder,
      this.valueAlignment,
      this.maxWidth,
      this.isExpanded,
      this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context)
              .inputDecorationTheme
              .enabledBorder!
              .borderSide
              .color,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: PopupMenuButton<T>(
        onSelected: onSelected,
        constraints: maxWidth != null
            ? BoxConstraints(
                maxWidth: maxWidth!,
                minWidth: 40,
              )
            : const BoxConstraints(minWidth: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        // alignment: Alignment.center,
        itemBuilder: itemBuilder,
        tooltip: tooltip,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16.0,
              ),
              child: Text(child ?? (placeholder ?? '...')),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
