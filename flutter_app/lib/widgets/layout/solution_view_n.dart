import 'package:dp_algebra/models/calc_result.dart';
import 'package:dp_algebra/widgets/layout/calc_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class SolutionView2 extends StatelessWidget {
  final CalcResult solution;

  const SolutionView2({
    Key? key,
    required this.solution,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            runSpacing: 12.0,
            children: Math.tex(
              '${solution.calculation.toTeX()}=${solution.result.toTeX()}',
              textScaleFactor: 1.4,
            ).texBreak().parts,
          ),
          CalcStepper(steps: solution.steps),
        ],
      ),
    );
  }
}
