import 'dart:math';

import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/models/calc/calc_result.dart';
import 'package:dp_algebra/models/input/matrix_model.dart';
import 'package:dp_algebra/pages/exercise/general/exercise_page.dart';
import 'package:dp_algebra/utils/exc_utils.dart';
import 'package:dp_algebra/utils/utils.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:dp_algebra/widgets/input/matrix_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class BinaryMatrixExc extends StatefulWidget {
  const BinaryMatrixExc({Key? key}) : super(key: key);

  @override
  State<BinaryMatrixExc> createState() => _BinaryMatrixExcState();
}

class _BinaryMatrixExcState extends State<BinaryMatrixExc> {
  Random random = Random();

  late Expression exercise;
  late CalcResult correctSolution;

  MatrixModel solution = MatrixModel(columns: 1, rows: 1);

  @override
  void initState() {
    super.initState();
    generateRandomExample();
  }

  @override
  Widget build(BuildContext context) {
    return ExercisePage(
      generateButtons: [
        ButtonRowItem(
          child: const Text('Sčítání'),
          onPressed: () {
            setState(() {
              generateEntryWiseExample('+');
            });
          },
        ),
        ButtonRowItem(
          child: const Text('Odčítání'),
          onPressed: () {
            setState(() {
              generateEntryWiseExample('-');
            });
          },
        ),
        ButtonRowItem(
          child: const Text('Násobení'),
          onPressed: () {
            setState(() {
              generateMultiplyExample();
            });
          },
        ),
        ButtonRowItem(
          child: const Text('Náhodně'),
          onPressed: () {
            setState(() {
              generateRandomExample();
            });
          },
        ),
      ],
      example: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        runSpacing: 12.0,
        children: Math.tex(
          '${exercise.toTeX(flags: {TexFlags.dontEnclose})} =',
          textScaleFactor: 1.4,
        ).texBreak().parts,
      ),
      result: MatrixInput(matrix: solution),
      resolveButtons: [
        ButtonRowItem(
          child: const Text('Zkontrolovat'),
          onPressed: () {
            // TODO: replace this
            AlgebraUtils.showMessage(
                context, isAnswerCorrect() ? 'Správně' : 'Špatně');
          },
        ),
      ],
      solution: correctSolution,
    );
  }

  bool isAnswerCorrect() => correctSolution.result == solution.toMatrix();

  void generateRandomExample() {
    List<String> operations = ['+', '-', '*'];
    String operation = operations[random.nextInt(operations.length)];
    if (operation == '*') {
      generateMultiplyExample();
    } else {
      generateEntryWiseExample(operation);
    }
  }

  void generateEntryWiseExample(String operation) {
    int rows = ExerciseUtils.generateSize();
    int cols = ExerciseUtils.generateSize();

    var matrixA = ExerciseUtils.generateMatrix(
      rows: rows,
      columns: cols,
    ).toMatrix();
    var matrixB = ExerciseUtils.generateMatrix(
      rows: rows,
      columns: cols,
    ).toMatrix();

    if (operation == '+') {
      exercise = Addition(left: matrixA, right: matrixB);
    } else if (operation == '-') {
      exercise = Subtraction(left: matrixA, right: matrixB);
    }
    correctSolution = CalcResult.calculate(exercise);
  }

  void generateMultiplyExample() {
    int rows = ExerciseUtils.generateSize();
    int cols = ExerciseUtils.generateSize();
    int cols2 = ExerciseUtils.generateSize();

    var matrixA = ExerciseUtils.generateMatrix(
      rows: rows,
      columns: cols,
    ).toMatrix();
    var matrixB = ExerciseUtils.generateMatrix(
      rows: cols,
      columns: cols2,
    ).toMatrix();

    exercise = Multiply(
      left: matrixA,
      right: matrixB,
    );
    correctSolution = CalcResult.calculate(exercise);
  }
}
