import 'dart:math';

import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/main.dart';
import 'package:dp_algebra/models/calc/calc_result.dart';
import 'package:dp_algebra/models/exc_state/variable_value.dart';
import 'package:dp_algebra/pages/exercise/general/exercise_page.dart';
import 'package:dp_algebra/utils/exc_utils.dart';
import 'package:dp_algebra/utils/utils.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:dp_algebra/widgets/input/solution_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class EquationExc extends StatefulWidget {
  const EquationExc({Key? key}) : super(key: key);

  @override
  State<EquationExc> createState() => _EquationExcState();
}

class _EquationExcState extends State<EquationExc> {
  Random random = Random();

  late Expression exercise;
  CalcResult? correctSolution;
  int variableCount = 0;

  Map<int, SolutionVariable> solution = {};

  @override
  void initState() {
    super.initState();
    generateSquareMatrix(ExerciseUtils.generateSize());
  }

  @override
  Widget build(BuildContext context) {
    return ExercisePage(
      generateButtons: [
        ButtonRowItem(
            child: const Text('Se čtvercovou maticí'),
            onPressed: () {
              setState(() {
                generateSquareMatrix(ExerciseUtils.generateSize());
                solution = {};
              });
            }),
        ButtonRowItem(
          child: const Text('Náhodně'),
          onPressed: () {
            setState(() {
              generateRandomMatrix();
              solution = {};
            });
          },
        ),
      ],
      example: Math.tex(
        '${exerciseToTeX()}, ',
        textScaleFactor: 1.4,
      ),
      result: SolutionInput(
        name: 'x',
        solution: solution,
        variableCount: variableCount,
      ),
      resolveButtons: [
        ButtonRowItem(
          child: const Text('Zkontrolovat'),
          onPressed: () {
            // TODO: replace this
            AlgebraUtils.showMessage(
                context, isAnswerCorrect() ? 'Správně' : 'Špatně');
          },
        ),
        ButtonRowItem(
          child: const Text('Nemá řešení'),
          onPressed: () {
            AlgebraUtils.showMessage(
                context, correctSolution == null ? 'Správně' : 'Špatně');
          },
        ),
      ],
    );
  }

  bool isAnswerCorrect() {
    if (correctSolution == null) return false;

    try {
      var filledSolution = ExerciseUtils.vectorFromSolutionMap(
        solution,
        variableCount,
      );
      return correctSolution?.result == filledSolution;
    } on Error catch (e) {
      // TODO: ideally show to user
      logger.e(e.toString());
      return false;
    }
  }

  String exerciseToTeX() {
    Matrix m = (exercise as GaussianElimination).matrix as Matrix;

    StringBuffer buffer = StringBuffer();
    buffer.write(r'\left( \begin{matrix} ');

    for (var row in m.rows) {
      for (var i = 0; i < (row as Vector).length(); i++) {
        if (i != row.length() - 1) {
          buffer.write(row[i].toTeX());

          if (i != row.length() - 2) {
            buffer.write(r'&');
          }
        }
      }
      buffer.write(r'\\');
    }

    buffer.write(r'\end{matrix} \middle\vert \, \begin{matrix} ');

    for (var row in m.rows) {
      buffer.write((row as Vector).items.last.toTeX());
      buffer.write(r'\\');
    }

    buffer.write(r'\end{matrix} \right)');
    return buffer.toString();
  }

  void setExercise(Matrix matrix, Vector vectorY) {
    variableCount = matrix.columnCount;
    var isSolvable = CalcResult.calculate(
      IsSolvable(matrix: matrix, vectorY: vectorY),
    );

    exercise = GaussianElimination(
      matrix: Matrix.toEquationMatrix(matrix, vectorY),
    );

    if (isSolvable.result is Boolean && (isSolvable.result as Boolean).value) {
      correctSolution = CalcResult.calculate(exercise);
    } else {
      correctSolution = null;
    }
  }

  void generateSquareMatrix(int size) {
    var matrix = ExerciseUtils.generateSquareMatrix(size);
    var vector = ExerciseUtils.generateVector(length: size);

    setExercise(matrix.toMatrix(), vector.toVector());
  }

  void generateRandomMatrix() {
    int rowsCount = ExerciseUtils.generateSize();

    var matrix = ExerciseUtils.generateMatrix(
      rows: rowsCount,
      columns: ExerciseUtils.generateSize(),
    );
    var vector = ExerciseUtils.generateVector(length: rowsCount);

    setExercise(matrix.toMatrix(), vector.toVector());
  }
}
