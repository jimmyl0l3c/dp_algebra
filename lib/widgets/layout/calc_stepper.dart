import 'package:dp_algebra/logic/general/extensions.dart';
import 'package:dp_algebra/logic/matrix/matrix.dart';
import 'package:dp_algebra/logic/matrix/matrix_operations.dart';
import 'package:dp_algebra/logic/step_models/general_op.dart';
import 'package:dp_algebra/logic/step_models/matrix_binary_op.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:fraction/fraction.dart';

class CalcStepper extends StatefulWidget {
  final List<CalcStep> steps;

  const CalcStepper({Key? key, required this.steps}) : super(key: key);

  @override
  State<CalcStepper> createState() => _CalcStepperState();
}

class _CalcStepperState extends State<CalcStepper> {
  int mainStep = 0;
  int innerStep = 0;

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
              child: const Text('<'),
              onPressed: () {
                setState(() {
                  if (innerStep > 0) {
                    innerStep--;
                  } else if (innerStep == 0 && mainStep > 0) {
                    mainStep--;
                    var innerLength =
                        widget.steps[mainStep].getInnerStepLength();
                    innerStep = innerLength > 0 ? innerLength - 1 : 0;
                  }
                });
              },
            ),
            ButtonRowItem(
              child: const Text('>'),
              onPressed: () {
                var innerLength = widget.steps[mainStep].getInnerStepLength();
                setState(() {
                  if (innerStep < innerLength - 1) {
                    innerLength++;
                  } else if (innerStep == innerLength - 1 &&
                      mainStep < widget.steps.length - 1) {
                    mainStep++;
                    innerStep = 0;
                  }
                });
              },
            ),
          ],
        ),
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          runSpacing: 12.0,
          children: widget.steps.isEmpty
              ? []
              : Math.tex(
                  _stepToTeX(widget.steps[mainStep]),
                ).texBreak().parts,
        ),
      ],
    );
  }

  String _stepToTeX(CalcStep step) {
    StringBuffer buffer = StringBuffer();

    if (step is MatrixBinaryOperation) {
      if (step.leftOperand is Fraction) {
        buffer.write((step.leftOperand as Fraction).toTeX());
      } else if (step.leftOperand is Matrix) {
        buffer.write((step.leftOperand as Matrix).toTeX());
      }

      buffer.write((step.type as MatrixOperation).symbol);

      buffer.write(step.matrix.toTeX());
    }

    return buffer.toString();
  }
}
