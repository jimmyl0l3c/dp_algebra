import 'package:flutter/material.dart';

import '../../models/calc/calc_result.dart';
import '../../widgets/forms/button_row.dart';
import '../../widgets/info_button.dart';
import '../../widgets/layout/calc_stepper.dart';

class ExerciseSolution extends StatefulWidget {
  final CalcResult? solution;
  final String? strSolution;
  final String? hintRef;

  const ExerciseSolution({
    Key? key,
    this.solution,
    this.strSolution,
    this.hintRef,
  }) : super(key: key);

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
          Row(
            mainAxisSize: MainAxisSize.min,
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
                ],
              ),
              if (widget.hintRef != null) const SizedBox(width: 8.0),
              if (widget.hintRef != null) InfoButton(refName: widget.hintRef!),
            ],
          ),
          const SizedBox(height: 8),
          if (showSolution && widget.solution != null)
            CalcStepper(
              key: ValueKey(widget.solution),
              steps: widget.solution!.steps,
            ),
          if (showSolution && widget.strSolution != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Text(widget.strSolution!),
            ),
        ],
      ),
    );
  }
}
