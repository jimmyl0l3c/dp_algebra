import 'dart:math';

import 'package:algebra_expressions/algebra_expressions.dart';
import 'package:big_fraction/big_fraction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../data/predefined_refs.dart';
import '../../../models/calc/calc_result.dart';
import '../../../utils/exc_utils.dart';
import '../../../utils/utils.dart';
import '../../../widgets/forms/button_row.dart';
import '../../../widgets/input/fraction_input.dart';
import '../../generic/exercise_page.dart';

class DeterminantExc extends StatefulWidget {
  const DeterminantExc({super.key});

  @override
  State<DeterminantExc> createState() => _DeterminantExcState();
}

class _DeterminantExcState extends State<DeterminantExc> {
  final Random random = Random();

  late Expression exercise;
  late CalcResult correctSolution;

  BigFraction solution = BigFraction.zero();

  @override
  void initState() {
    super.initState();
    generateDeterminant(2);
  }

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
        '${exercise.toTeX()} =',
        textScaleFactor: 1.4,
      ),
      result: FractionInput(
        maxWidth: 100,
        onChanged: (BigFraction? value) {
          if (value == null) return;
          solution = value;
        },
        value: solution.toDouble() != 0.0 ? solution.toString() : null,
      ),
      resolveButtons: [
        ButtonRowItem(
            child: const Text('Zkontrolovat'),
            onPressed: () {
              showSnackBarMessage(
                  context, isAnswerCorrect() ? 'Správně' : 'Špatně');
            })
      ],
      solution: correctSolution,
      hintRef: PredefinedRef.determinant.refName,
    );
  }

  bool isAnswerCorrect() => Scalar(solution) == correctSolution.result;

  void generateRandomDeterminant() {
    solution = BigFraction.zero();

    int size = 1 + ExerciseUtils.generateSize();
    generateDeterminant(size);
  }

  void generateDeterminant(int size) {
    var determinant = ExerciseUtils.generateMatrix(
      rows: size,
      columns: size,
    ).toMatrix();
    exercise = Determinant(det: determinant);
    correctSolution = CalcResult.calculate(exercise);
    solution = BigFraction.zero();
  }
}
