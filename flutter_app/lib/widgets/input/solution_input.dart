import 'package:flutter/material.dart';

import '../../models/input/solution_variable.dart';
import '../hint.dart';
import 'decorate_vector_input.dart';
import 'solution_value_input.dart';

class SolutionInput extends StatefulWidget {
  final Map<int, SolutionVariable> solution;
  final String name;
  final int variableCount;

  const SolutionInput({
    super.key,
    required this.solution,
    required this.name,
    required this.variableCount,
  });

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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.name),
                  const SizedBox(width: 8.0),
                  const Hint(
                    message:
                        'Pokud má soustava více řešení, zadejte řešení parametricky, např. (x0, 2x0+1)',
                  ),
                ],
              ),
            ),
            Wrap(
              direction: Axis.horizontal,
              runSpacing: 4.0,
              spacing: 2.0,
              children: [
                for (var i = 0; i < widget.variableCount; i++)
                  decorateVectorInput(
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
