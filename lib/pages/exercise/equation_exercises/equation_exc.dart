import 'dart:math';

import 'package:dp_algebra/matrices/equation_matrix.dart';
import 'package:dp_algebra/matrices/equation_solution.dart';
import 'package:dp_algebra/matrices/vector.dart';
import 'package:dp_algebra/pages/exercise/utils.dart';
import 'package:dp_algebra/widgets/vector_input.dart';
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
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    equationMatrix =
                        generateSquareMatrix(ExerciseUtils.generateSize());
                  });
                },
                child: Text('Se čtvercovou maticí'),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    equationMatrix = generateRandomMatrix();
                  });
                },
                child: const Text('Náhodně'),
              ),
              const VerticalDivider(),
              OutlinedButton(
                onPressed: () {
                  // TODO: replace this
                  ExerciseUtils.showError(
                      context, isAnswerCorrect() ? 'Správně' : 'Špatně');
                },
                child: const Text('Zkontrolovat'),
              ),
              OutlinedButton(
                onPressed: () {
                  // TODO: replace this
                  ExerciseUtils.showError(context,
                      !equationMatrix.isSolvable() ? 'Správně' : 'Špatně');
                },
                child: const Text('Nemá řešení'),
              ),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.horizontal,
            children: [
              Math.tex(
                '${equationMatrix.toTeX()} =',
                textScaleFactor: 1.4,
              ),
              SizedBox(
                width: 500,
                child: VectorInput(
                  vector: solution,
                  name: 'x',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool isAnswerCorrect() {
    if (!equationMatrix.isSolvable()) return false;

    if (equationMatrix.isSolvableByCramer()) {
      Vector correctSolution = equationMatrix.solveByCramer();
      return correctSolution == solution;
    } else {
      GeneralSolution correctGeneralSolution = equationMatrix.solveByGauss();
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
