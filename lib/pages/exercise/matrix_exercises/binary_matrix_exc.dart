import 'dart:math';

import 'package:dp_algebra/matrices/matrix.dart';
import 'package:dp_algebra/pages/exercise/utils.dart';
import 'package:dp_algebra/widgets/button_row.dart';
import 'package:dp_algebra/widgets/matrix_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class BinaryMatrixExc extends StatefulWidget {
  const BinaryMatrixExc({Key? key}) : super(key: key);

  @override
  State<BinaryMatrixExc> createState() => _BinaryMatrixExcState();
}

class _BinaryMatrixExcState extends State<BinaryMatrixExc> {
  Random random = Random();

  Matrix matrixA = Matrix(columns: 1, rows: 1);
  Matrix matrixB = Matrix(columns: 1, rows: 1);
  Matrix solution = Matrix(columns: 1, rows: 1);
  String operationSymbol = '+';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
        vertical: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.horizontal,
            children: [
              const Text('Vygenerovat: '),
              ButtonRow(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                children: const [
                  Text('Sčítání'),
                  Text('Odčítání'),
                  Text('Násobení'),
                  Text('Náhodně'),
                ],
                onPressed: (i) {
                  switch (i) {
                    case 0:
                      setState(() {
                        generateEntryWiseExample('+');
                      });
                      break;
                    case 1:
                      setState(() {
                        generateEntryWiseExample('-');
                      });
                      break;
                    case 2:
                      setState(() {
                        generateMultiplyExample();
                      });
                      break;
                    default:
                      setState(() {
                        generateRandomExample();
                      });
                      break;
                  }
                },
              ),
              const VerticalDivider(),
              ElevatedButton(
                onPressed: () {
                  // TODO: replace this
                  ExerciseUtils.showError(
                      context, isAnswerCorrect() ? 'Správně' : 'Špatně');
                },
                child: const Text('Zkontrolovat'),
              ),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.horizontal,
            children: [
              Math.tex(
                '${matrixA.toTeX()} $operationSymbol ${matrixB.toTeX()} =',
                textScaleFactor: 1.4,
              ),
              MatrixInput(matrix: solution, name: 'C', deleteMatrix: () {}),
            ],
          ),
        ],
      ),
    );
  }

  bool isAnswerCorrect() {
    Matrix? correctSolution;
    if (operationSymbol == '+') {
      correctSolution = matrixA + matrixB;
    } else if (operationSymbol == '-') {
      correctSolution = matrixA - matrixB;
    } else if (operationSymbol == r'\cdot') {
      correctSolution = matrixA * matrixB;
    }

    return correctSolution != null && correctSolution == solution;
  }

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
  }

  void generateMultiplyExample() {
    operationSymbol = r'\cdot';
    int rows = ExerciseUtils.generateSize();
    int cols = ExerciseUtils.generateSize();
    int cols2 = ExerciseUtils.generateSize();
    matrixA = ExerciseUtils.generateMatrix(rows: rows, columns: cols);
    matrixB = ExerciseUtils.generateMatrix(rows: cols, columns: cols2);
  }
}
