import 'dart:math';

import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/logic/matrix/matrix_model.dart';
import 'package:dp_algebra/models/calc_result.dart';
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

  MatrixModel matrixA = MatrixModel(columns: 1, rows: 1);
  MatrixModel matrixB = MatrixModel(columns: 1, rows: 1);
  CalcResult? correctSolution;

  MatrixModel solution = MatrixModel(columns: 1, rows: 1);
  String operationSymbol = '+';

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
          '${matrixA.toTeX()} $operationSymbol ${matrixB.toTeX()} =',
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
            })
      ],
    );
  }

  bool isAnswerCorrect() => correctSolution?.result == solution.toMatrix();

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
    operationSymbol = operation;
    int rows = ExerciseUtils.generateSize();
    int cols = ExerciseUtils.generateSize();
    matrixA = ExerciseUtils.generateMatrix(rows: rows, columns: cols);
    matrixB = ExerciseUtils.generateMatrix(rows: rows, columns: cols);

    if (operationSymbol == '+') {
      correctSolution = CalcResult.calculate(
        Addition(
          left: matrixA.toMatrix(),
          right: matrixB.toMatrix(),
        ),
      );
    } else if (operationSymbol == '-') {
      correctSolution = CalcResult.calculate(
        Subtraction(
          left: matrixA.toMatrix(),
          right: matrixB.toMatrix(),
        ),
      );
    }
  }

  void generateMultiplyExample() {
    operationSymbol = r'\cdot';
    int rows = ExerciseUtils.generateSize();
    int cols = ExerciseUtils.generateSize();
    int cols2 = ExerciseUtils.generateSize();
    matrixA = ExerciseUtils.generateMatrix(rows: rows, columns: cols);
    matrixB = ExerciseUtils.generateMatrix(rows: cols, columns: cols2);

    correctSolution = CalcResult.calculate(
      Multiply(
        left: matrixA.toMatrix(),
        right: matrixB.toMatrix(),
      ),
    );
  }
}
