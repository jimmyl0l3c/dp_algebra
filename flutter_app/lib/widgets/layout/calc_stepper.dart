import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

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
              child: const Text('<'),
              onPressed: () {
                setState(() {
                  if (step > 0) {
                    step--;
                  }
                });
              },
            ),
            ButtonRowItem(
              child: const Text('>'),
              onPressed: () {
                setState(() {
                  if (step < widget.steps.length - 1) {
                    step++;
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
              : Math.tex(_stepToTeX(widget.steps[step])).texBreak().parts,
        ),
        // TODO: add hint (what operation is being done)
        // Wrap(
        //   direction: Axis.horizontal,
        //   alignment: WrapAlignment.center,
        //   crossAxisAlignment: WrapCrossAlignment.center,
        //   runAlignment: WrapAlignment.center,
        //   runSpacing: 12.0,
        //   children: widget.steps.isEmpty ||
        //           widget.steps[mainStep].getInnerStepLength() == 0
        //       ? []
        //       : Math.tex(
        //           _stepToTeX(widget.steps[mainStep]),
        //         ).texBreak().parts,
        // ),
      ],
    );
  }

  String _stepToTeX(Expression step) {
    print(step.toTeX()); // TODO: debug only, remove
    return step.toTeX();
    // StringBuffer buffer = StringBuffer();
    //
    // if (step is MatrixBinaryOperation) {
    //   if (step.leftOperand is Fraction) {
    //     buffer.write((step.leftOperand as Fraction).toTeX());
    //   } else if (step.leftOperand is Matrix) {
    //     buffer.write((step.leftOperand as Matrix).toTeX());
    //   }
    //
    //   buffer.write((step.type as MatrixOperation).symbol);
    //
    //   buffer.write(step.matrix.toTeX());
    // }
    //
    // return buffer.toString();
  }
}
