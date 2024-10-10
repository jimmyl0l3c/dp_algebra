import 'dart:math';

import 'package:algebra_expressions/algebra_expressions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../data/predefined_refs.dart';
import '../../../models/calc/calc_result.dart';
import '../../../models/input/matrix_model.dart';
import '../../../utils/exc_utils.dart';
import '../../../utils/utils.dart';
import '../../../widgets/forms/button_row.dart';
import '../../../widgets/input/matrix_input.dart';
import '../../generic/exercise_page.dart';

class BinaryMatrixExc extends StatefulWidget {
  const BinaryMatrixExc({super.key});

  @override
  State<BinaryMatrixExc> createState() => _BinaryMatrixExcState();
}

class _BinaryMatrixExcState extends State<BinaryMatrixExc> {
  final Random random = Random();

  late Expression exercise;
  late CalcResult correctSolution;
  late String hintRef;

  final MatrixModel solution = MatrixModel(columns: 1, rows: 1);

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
            showSnackBarMessage(
                context, isAnswerCorrect() ? 'Správně' : 'Špatně');
          },
        ),
      ],
      solution: correctSolution,
      hintRef: hintRef,
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
    solution.clear();

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
    hintRef = PredefinedRef.matrixAddition.refName;
  }

  void generateMultiplyExample() {
    solution.clear();

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
    hintRef = PredefinedRef.matrixMultiplication.refName;
  }
}
