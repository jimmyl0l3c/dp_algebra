import 'package:flutter/material.dart';

class StyledDropdownButton<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final AlignmentGeometry? valueAlignment;
  final double? maxWidth;
  final bool? isExpanded;

  const StyledDropdownButton({
    Key? key,
    this.value,
    this.items,
    this.onChanged,
    this.valueAlignment,
    this.maxWidth,
    this.isExpanded,
  }) : super(key: key);

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
      child: ConstrainedBox(
        constraints: maxWidth != null
            ? BoxConstraints(
                maxWidth: maxWidth!,
                minWidth: 40,
              )
            : const BoxConstraints(minWidth: 40),
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          // dropdownColor: Colors.orange,
          borderRadius: BorderRadius.circular(6),
          alignment: Alignment.center,
          iconEnabledColor: Theme.of(context).colorScheme.onPrimary,
          underline: Container(),
          isExpanded: isExpanded ?? false,
          selectedItemBuilder: (context) {
            if (items == null) return [];
            return items!.map<Widget>((e) {
              return Container(
                alignment: valueAlignment ?? Alignment.center,
                child: Text(e.value.toString()),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
