import 'dart:math';

import 'package:dp_algebra/logic/equation_matrix/equation_matrix.dart';
import 'package:dp_algebra/logic/equation_matrix/equation_solution.dart';
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

  EquationMatrix equationMatrix = EquationMatrix(columns: 2, rows: 1);
  Map<int, SolutionVariable> solution = {};

  @override
  Widget build(BuildContext context) {
    return ExercisePage(
      generateButtons: [
        ButtonRowItem(
            child: const Text('Se čtvercovou maticí'),
            onPressed: () {
              setState(() {
                equationMatrix =
                    generateSquareMatrix(ExerciseUtils.generateSize());
                solution = {};
              });
            }),
        ButtonRowItem(
          child: const Text('Náhodně'),
          onPressed: () {
            setState(() {
              equationMatrix = generateRandomMatrix();
              solution = {};
            });
          },
        ),
      ],
      example: Math.tex(
        '${equationMatrix.toTeX()}, ',
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
                context, !equationMatrix.isSolvable() ? 'Správně' : 'Špatně');
          },
        ),
      ],
    );
  }

  bool isAnswerCorrect() {
    if (!equationMatrix.isSolvable()) return false;
    GeneralSolution correctSolution = equationMatrix.solveByGauss();

    try {
      GeneralSolution filledSolution = GeneralSolution.fromVariableMap(
        solution,
        varCount: equationMatrix.getColumns() - 1,
      );
      return correctSolution == filledSolution;
    } on Error {
      // TODO: at least log the error, ideally show to user
      return false;
    }
  }

  EquationMatrix generateSquareMatrix(int size) =>
      EquationMatrix.fromMatrix(ExerciseUtils.generateMatrix(
        rows: size,
        columns: size + 1,
      ));

  EquationMatrix generateRandomMatrix() =>
      EquationMatrix.fromMatrix(ExerciseUtils.generateMatrix(
        rows: ExerciseUtils.generateSize() + 1,
        columns: ExerciseUtils.generateSize() + 1,
      ));
}
