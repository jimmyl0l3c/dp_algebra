import 'package:flutter/material.dart';

import '../../models/calc/calc_result.dart';
import '../../widgets/forms/button_row.dart';
import 'exercise_solution.dart';

class ExercisePage extends StatelessWidget {
  final List<ButtonRowItem> generateButtons;
  final Widget example;
  final Widget? result;
  final List<ButtonRowItem> resolveButtons;
  final CalcResult? solution;
  final String? strSolution;
  final String? hintRef;

  const ExercisePage({
    super.key,
    required this.generateButtons,
    required this.example,
    this.result,
    required this.resolveButtons,
    this.solution,
    this.strSolution,
    this.hintRef,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4.0,
          vertical: 12.0,
        ),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 8.0,
                  children: [
                    const Text('Vygenerovat: '),
                    ButtonRow(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      children: generateButtons,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: example,
              ),
              if (result != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: result,
                ),
              ButtonRow(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                children: resolveButtons,
              ),
              if (solution != null || strSolution != null)
                ExerciseSolution(
                  solution: solution,
                  strSolution: strSolution,
                  hintRef: hintRef,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
