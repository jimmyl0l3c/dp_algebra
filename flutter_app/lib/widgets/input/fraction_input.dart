import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fraction/fraction.dart';

class FractionInput extends StatelessWidget {
  final ValueChanged<Fraction?> onChanged;
  final TextEditingController? controller;
  final double? maxWidth;

  FractionInput({
    Key? key,
    required this.onChanged,
    required value,
    this.maxWidth,
  })  : controller = TextEditingController(text: value),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: maxWidth != null
          ? BoxConstraints(maxWidth: maxWidth!)
          : const BoxConstraints(),
      child: TextFormField(
        onChanged: (value) {
          if (value.isEmpty) {
            onChanged.call(Fraction(0));
          } else if (value.contains('.')) {
            double? dValue = double.tryParse(value);
            if (dValue == null) {
              onChanged.call(null);
              return;
            }
            onChanged.call(dValue.toFraction());
          } else {
            if (value.startsWith('/')) value = '0$value';
            if (!value.isFraction) return;
            onChanged.call(value.toFraction());
          }
        },
        controller: controller,
        inputFormatters: [
          FilteringTextInputFormatter(
            RegExp(r'^[+-]?\d*[./]?\d*'),
            allow: true,
          )
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          if (value == null || value.isEmpty) return null;
          if (value.contains('/')) {
            int index = value.indexOf('/');
            if (index == value.length - 1) {
              return 'Nelze dělit nulou';
            }
            int? parsed = int.tryParse(value.substring(index + 1));
            if (parsed == null || parsed == 0) {
              return 'Nelze dělit nulou';
            }
          }
          if (value.contains('.')) {
            return double.tryParse(value) == null ? 'Neplatná hodnota' : null;
          }
          if (value.startsWith('/')) value = '0$value';
          if (!value.isFraction) return 'Neplatná hodnota';
          return null;
        },
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true, signed: true),
        decoration: const InputDecoration(
          hintText: '0',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
