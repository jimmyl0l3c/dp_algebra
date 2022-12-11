import 'dart:math';

import 'package:dp_algebra/logic/equation_matrix/equation_matrix.dart';
import 'package:dp_algebra/logic/equation_matrix/equation_solution.dart';
import 'package:dp_algebra/logic/vector/vector.dart';
import 'package:dp_algebra/pages/exercise/general/exercise_page.dart';
import 'package:dp_algebra/utils/exc_utils.dart';
import 'package:dp_algebra/utils/utils.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:dp_algebra/widgets/input/vector_input.dart';
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
  Vector solution = Vector(length: 1);

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
              });
            }),
        ButtonRowItem(
          child: const Text('Náhodně'),
          onPressed: () {
            setState(() {
              equationMatrix = generateRandomMatrix();
            });
          },
        ),
      ],
      example: Math.tex(
        '${equationMatrix.toTeX()}, ',
        textScaleFactor: 1.4,
      ),
      result: VectorInput(
        vector: solution,
        name: 'x',
      ),
      resolveButtons: [
        ButtonRowItem(
          child: const Text('Zkontrolovat'),
          onPressed: () {
            // TODO: replace this
            AlgebraUtils.showError(
                context, isAnswerCorrect() ? 'Správně' : 'Špatně');
          },
        ),
        ButtonRowItem(
          child: const Text('Nemá řešení'),
          onPressed: () {
            AlgebraUtils.showError(
                context, !equationMatrix.isSolvable() ? 'Správně' : 'Špatně');
          },
        ),
      ],
    );
  }

  bool isAnswerCorrect() {
    if (!equationMatrix.isSolvable()) return false;

    if (equationMatrix.isSolvableByCramer()) {
      Vector correctSolution = equationMatrix.solveByCramer();
      return correctSolution == solution;
    } else {
      GeneralSolution correctGeneralSolution = equationMatrix.solveByGauss();
      if (correctGeneralSolution.isSingleSolution()) {
        return correctGeneralSolution.toVectorList().first == solution;
      }

      // TODO: compare, make it possible to fill general solutions
    }

    return false;
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
