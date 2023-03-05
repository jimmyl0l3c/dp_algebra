import 'dart:math';

import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/logic/matrix/matrix_model.dart';
import 'package:dp_algebra/models/calc_result.dart';
import 'package:dp_algebra/pages/exercise/general/exercise_page.dart';
import 'package:dp_algebra/utils/exc_utils.dart';
import 'package:dp_algebra/utils/utils.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:dp_algebra/widgets/input/fraction_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:fraction/fraction.dart';

class DeterminantExc extends StatefulWidget {
  const DeterminantExc({Key? key}) : super(key: key);

  @override
  State<DeterminantExc> createState() => _DeterminantExcState();
}

class _DeterminantExcState extends State<DeterminantExc> {
  Random random = Random();

  MatrixModel determinant = MatrixModel(columns: 1, rows: 1);
  CalcResult? correctSolution;
  Fraction solution = Fraction(0);

  @override
  Widget build(BuildContext context) {
    return ExercisePage(
      generateButtons: [
        ButtonRowItem(
          child: const Text('2x2'),
          onPressed: () {
            setState(() {
              generateDeterminant(2);
            });
          },
        ),
        ButtonRowItem(
          child: const Text('3x3'),
          onPressed: () {
            setState(() {
              generateDeterminant(3);
            });
          },
        ),
        ButtonRowItem(
          child: const Text('> 3x3'),
          onPressed: () {
            setState(() {
              generateDeterminant(4 + random.nextInt(3));
            });
          },
        ),
        ButtonRowItem(
          child: const Text('Náhodně'),
          onPressed: () {
            setState(() {
              generateRandomDeterminant();
            });
          },
        ),
      ],
      example: Math.tex(
        '${determinant.toTeX(isDeterminant: true)} =',
        textScaleFactor: 1.4,
      ),
      result: FractionInput(
        maxWidth: 100,
        onChanged: (Fraction? value) {
          if (value == null) return;
          solution = value;
        },
        value: solution.toDouble() != 0.0 ? solution.toString() : null,
      ),
      resolveButtons: [
        ButtonRowItem(
            child: const Text('Zkontrolovat'),
            onPressed: () {
              // TODO: replace this
              AlgebraUtils.showMessage(
                  context, isAnswerCorrect() ? 'Správně' : 'Špatně');
            })
      ],
    );
  }

  bool isAnswerCorrect() => Scalar(value: solution) == correctSolution?.result;

  void generateRandomDeterminant() {
    int size = 1 + ExerciseUtils.generateSize();
    return generateDeterminant(size);
  }

  void generateDeterminant(int size) {
    determinant = ExerciseUtils.generateMatrix(rows: size, columns: size);
    correctSolution = CalcResult.calculate(
      Determinant(det: determinant.toMatrix()),
    );
  }
}
