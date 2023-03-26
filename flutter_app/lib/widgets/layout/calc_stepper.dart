import 'package:algebra_lib/algebra_lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../main.dart';
import '../forms/button_row.dart';

class CalcStepper extends StatefulWidget {
  final List<Expression> steps;

  const CalcStepper({Key? key, required this.steps}) : super(key: key);

  @override
  State<CalcStepper> createState() => _CalcStepperState();
}

class _CalcStepperState extends State<CalcStepper> {
  int step = 0;

  @override
  void initState() {
    step = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonRow(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          children: [
            ButtonRowItem(
              child: const Icon(Icons.first_page),
              onPressed: () {
                if (step == 0) return;
                setState(() {
                  step = 0;
                });
              },
            ),
            ButtonRowItem(
              child: const Icon(Icons.navigate_before),
              onPressed: () {
                if (step > 0) {
                  setState(() {
                    step--;
                  });
                }
              },
            ),
            ButtonRowItem(
              child: const Icon(Icons.navigate_next),
              onPressed: () {
                if (step < widget.steps.length - 1) {
                  setState(() {
                    step++;
                  });
                }
              },
            ),
            ButtonRowItem(
              child: const Icon(Icons.last_page),
              onPressed: () {
                int newStep = widget.steps.length - 1;

                if (step == newStep) return;
                setState(() {
                  step = newStep;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          runSpacing: 12.0,
          children: widget.steps.isEmpty
              ? []
              : Math.tex(
                  _stepToTeX(widget.steps[step]),
                  mathStyle: MathStyle.display,
                  textScaleFactor: 1.2,
                ).texBreak().parts,
        ),
        // TODO: add hint (what operation is being done)
      ],
    );
  }

  String _stepToTeX(Expression step) {
    logger.d('Calculation step: ${step.toTeX()}');
    return step.toTeX();
  }
}
