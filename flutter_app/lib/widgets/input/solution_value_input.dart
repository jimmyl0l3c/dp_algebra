import 'package:big_fraction/big_fraction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/input/solution_variable.dart';
import '../../utils/utils.dart';

class SolutionValueInput extends StatelessWidget {
  final ValueChanged<List<VariableValue>?> onChanged;
  final TextEditingController? controller;
  final double? maxWidth;
  final int variableCount;

  SolutionValueInput({
    super.key,
    required this.onChanged,
    required value,
    this.maxWidth,
    required this.variableCount,
  }) : controller = TextEditingController(text: value);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: maxWidth != null
          ? BoxConstraints(maxWidth: maxWidth!)
          : const BoxConstraints(),
      child: TextFormField(
        onChanged: (value) {
          if (value.isEmpty) {
            onChanged.call([VariableValue(value: BigFraction.zero())]);
            return;
          }

          List<VariableValue> values = [];
          var match = RegExp(r'([+-]?\d*[./]?\d*)((x\d+)?)').allMatches(value);
          for (var m in match) {
            if (m.groupCount != 3 || m[0]!.isEmpty) {
              continue;
            }

            var numericValue = parseFraction(m[1] ?? '');
            var variable = m[2];
            int? variableInt;

            if (numericValue == null &&
                m[1]!.isNotEmpty &&
                (m[1]!.length > 1 || !m[1]!.contains(RegExp(r'[+-]')))) {
              return; // TODO: throw error
            }

            if (variable != null && variable.isNotEmpty) {
              if (!variable.startsWith('x') || variable.length < 2) {
                return; // TODO: throw error
              }

              variableInt = int.tryParse(variable.substring(1));
              if (variableInt == null) {
                return; // TODO: throw error
              }

              numericValue ??= BigFraction.one();
            } else {
              variable = null;
            }

            if (m[1] == '-') {
              numericValue = BigFraction.minusOne();
            }

            values.add(VariableValue(
              value: numericValue,
              variable: variableInt,
            ));
          }
          onChanged.call(values);
        },
        controller: controller,
        inputFormatters: [
          FilteringTextInputFormatter(
            RegExp(r'([+-]?\d*[./]?\d*(x\d*)*)*'),
            allow: true,
          )
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          if (value == null || value.isEmpty) return null;

          var match =
              RegExp(r'(?:[+-]?\d*[./]?\d*(x\d+)?)*').stringMatch(value);
          if (match == null || match.length != value.length) {
            return 'Nesprávný formát';
          }
          return null;
        },
        decoration: const InputDecoration(
          hintText: '0',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
