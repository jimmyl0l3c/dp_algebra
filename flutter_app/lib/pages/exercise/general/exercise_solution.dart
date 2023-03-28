import 'package:flutter/material.dart';

import '../../../models/calc/calc_result.dart';
import '../../../widgets/forms/button_row.dart';
import '../../../widgets/layout/calc_stepper.dart';

class ExerciseSolution extends StatefulWidget {
  final CalcResult solution;

  const ExerciseSolution({Key? key, required this.solution}) : super(key: key);

  @override
  State<ExerciseSolution> createState() => _ExerciseSolutionState();
}

class _ExerciseSolutionState extends State<ExerciseSolution> {
  bool showSolution = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          ButtonRow(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              children: [
                ButtonRowItem(
                    child: showSolution
                        ? const Text('Skrýt postup')
                        : const Text('Zobrazit postup'),
                    onPressed: () {
                      setState(() {
                        showSolution = !showSolution;
                      });
                    })
              ]),
          const SizedBox(height: 8),
          if (showSolution)
            CalcStepper(
              key: ValueKey(widget.solution),
              steps: widget.solution.steps,
            ),
        ],
      ),
    );
  }
}
