import 'dart:math';

import 'package:algebra_expressions/algebra_expressions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../data/predefined_refs.dart';
import '../../../main.dart';
import '../../../models/calc/calc_result.dart';
import '../../../models/input/solution_variable.dart';
import '../../../utils/exc_utils.dart';
import '../../../utils/utils.dart';
import '../../../widgets/forms/button_row.dart';
import '../../../widgets/input/solution_input.dart';
import '../../generic/exercise_page.dart';

class EquationExc extends StatefulWidget {
  const EquationExc({super.key});

  @override
  State<EquationExc> createState() => _EquationExcState();
}

class _EquationExcState extends State<EquationExc> {
  final Random random = Random();

  late Expression exercise;
  CalcResult? correctSolution;
  CalcResult? isSolvable;
  int variableCount = 0;

  Map<int, SolutionVariable> solution = {};

  @override
  void initState() {
    super.initState();
    _generateSquareMatrix(ExerciseUtils.generateSize());
  }

  @override
  Widget build(BuildContext context) {
    return ExercisePage(
      generateButtons: [
        ButtonRowItem(
            child: const Text('Se čtvercovou maticí'),
            onPressed: () {
              setState(() {
                _generateSquareMatrix(ExerciseUtils.generateSize());
              });
            }),
        ButtonRowItem(
          child: const Text('Náhodně'),
          onPressed: () {
            setState(() {
              _generateRandomMatrix();
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
            showSnackBarMessage(
                context, isAnswerCorrect() ? 'Správně' : 'Špatně');
          },
        ),
        ButtonRowItem(
          child: const Text('Nemá řešení'),
          onPressed: () {
            showSnackBarMessage(
                context, correctSolution == null ? 'Správně' : 'Špatně');
          },
        ),
      ],
      solution: correctSolution ?? isSolvable,
      strSolution: correctSolution == null ? 'Soustava nemá řešení' : null,
      hintRef: PredefinedRef.gaussianElimination.refName,
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
      for (var i = 0; i < (row as Vector).length; i++) {
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
      buffer.write((row as Vector).items.last.toTeX());
      buffer.write(r'\\');
    }

    buffer.write(r'\end{matrix} \right)');
    return buffer.toString();
  }

  void _setExercise(Matrix matrix, Vector vectorY) {
    variableCount = matrix.columnCount;
    isSolvable = CalcResult.calculate(
      IsSolvable(matrix: matrix, vectorY: vectorY),
    );

    exercise = GaussianElimination(
      matrix: Matrix.toEquationMatrix(matrix, vectorY),
    );

    if (isSolvable?.result is Boolean &&
        (isSolvable!.result as Boolean).value) {
      correctSolution = CalcResult.calculate(exercise);
    } else {
      correctSolution = null;
    }
    solution = {};
  }

  void _generateSquareMatrix(int size) {
    var matrix = ExerciseUtils.generateSquareMatrix(size);
    var vector = ExerciseUtils.generateVector(length: size);

    _setExercise(matrix.toMatrix(), vector.toVector());
  }

  void _generateRandomMatrix() {
    int rowsCount = ExerciseUtils.generateSize();

    var matrix = ExerciseUtils.generateMatrix(
      rows: rowsCount,
      columns: ExerciseUtils.generateSize(),
    );
    var vector = ExerciseUtils.generateVector(length: rowsCount);

    _setExercise(matrix.toMatrix(), vector.toVector());
  }
}
