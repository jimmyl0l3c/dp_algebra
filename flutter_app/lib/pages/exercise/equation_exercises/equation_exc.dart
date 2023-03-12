import 'dart:math';

import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/logic/equation_matrix/equation_matrix.dart';
import 'package:dp_algebra/models/calc_result.dart';
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

  EquationMatrix equationMatrix = EquationMatrix(columns: 2, rows: 1);
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
        variableCount: equationMatrix.getColumns() - 1,
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
      // TODO: implement
      // GeneralSolution filledSolution = GeneralSolution.fromVariableMap(
      //   solution,
      //   varCount: equationMatrix.getColumns() - 1,
      // );
      // return correctSolution == filledSolution;
    } on Error {
      // TODO: at least log the error, ideally show to user
      return false;
    }
    return false;
  }

  String exerciseToTeX() {
    Matrix m = (exercise as GaussianElimination).matrix as Matrix;

    StringBuffer buffer = StringBuffer();
    buffer.write(r'\left( \begin{matrix} ');

    for (var row in m.rows) {
      for (var i = 0; i < row.length; i++) {
        if (i != row.length - 1) {
          buffer.write(row[i].toTeX());

          if (i != row.length - 2) {
            buffer.write(r'&');
          }
        }
      }
      buffer.write(r'\\');
    }

    buffer.write(r'\end{matrix} \middle\vert \, \begin{matrix} ');

    for (var row in m.rows) {
      buffer.write(row.last.toTeX());
      buffer.write(r'\\');
    }

    buffer.write(r'\end{matrix} \right)');
    return buffer.toString();
  }

  void setExercise(Matrix matrix, Vector vectorY) {
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
