import 'package:flutter/material.dart';

class StyledDropdownButton<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;

  const StyledDropdownButton({
    Key? key,
    this.value,
    this.items,
    this.onChanged,
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
      child: DecoratedBox(
        decoration: const BoxDecoration(),
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          borderRadius: BorderRadius.circular(6),
          alignment: Alignment.center,
          iconEnabledColor: Theme.of(context).colorScheme.onPrimary,
          underline: Container(),
        ),
      ),
    );
  }
}
