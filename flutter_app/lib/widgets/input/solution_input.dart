import 'package:dp_algebra/models/exc_state/variable_value.dart';
import 'package:dp_algebra/widgets/input/input_utils.dart';
import 'package:dp_algebra/widgets/input/solution_value_input.dart';
import 'package:flutter/material.dart';

class SolutionInput extends StatefulWidget {
  final Map<int, SolutionVariable> solution;
  final String name;
  final int variableCount;

  const SolutionInput({
    Key? key,
    required this.solution,
    required this.name,
    required this.variableCount,
  }) : super(key: key);

  @override
  State<SolutionInput> createState() => _SolutionInputState();
}

class _SolutionInputState extends State<SolutionInput> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(widget.name),
            ),
            Wrap(
              direction: Axis.horizontal,
              runSpacing: 4.0,
              spacing: 2.0,
              children: [
                for (var i = 0; i < widget.variableCount; i++)
                  InputUtils.decorateVector(
                    SolutionValueInput(
                      maxWidth: 100,
                      onChanged: (List<VariableValue>? value) {
                        if (value == null) return;

                        widget.solution[i] = SolutionVariable(
                          variables: List.from(value),
                        );
                      },
                      value: widget.solution.containsKey(i)
                          ? widget.solution[i].toString()
                          : '',
                      variableCount: widget.variableCount,
                    ),
                    i,
                    widget.variableCount,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
