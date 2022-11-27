import 'dart:math';

import 'package:dp_algebra/matrices/matrix.dart';
import 'package:dp_algebra/pages/exercise/utils.dart';
import 'package:dp_algebra/widgets/button_row.dart';
import 'package:dp_algebra/widgets/fraction_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:fraction/fraction.dart';

class DeterminantExc extends StatefulWidget {
  const DeterminantExc({Key? key}) : super(key: key);

  @override
  State<DeterminantExc> createState() => _DeterminantExcState();
}

class _DeterminantExcState extends State<DeterminantExc> {
  Random random = Random();

  Matrix determinant = Matrix(columns: 1, rows: 1);
  Fraction solution = Fraction(0);

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
                children: [
                  ButtonRowItem(
                    child: const Text('2x2'),
                    onPressed: () {
                      setState(() {
                        determinant = generateDeterminant(2);
                      });
                    },
                  ),
                  ButtonRowItem(
                    child: const Text('3x3'),
                    onPressed: () {
                      setState(() {
                        determinant = generateDeterminant(3);
                      });
                    },
                  ),
                  ButtonRowItem(
                    child: const Text('> 3x3'),
                    onPressed: () {
                      setState(() {
                        determinant =
                            generateDeterminant(4 + random.nextInt(3));
                      });
                    },
                  ),
                  ButtonRowItem(
                    child: const Text('Náhodně'),
                    onPressed: () {
                      setState(() {
                        determinant = generateRandomDeterminant();
                      });
                    },
                  ),
                ],
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
                '${determinant.toTeX(isDeterminant: true)} =',
                textScaleFactor: 1.4,
              ),
              SizedBox(
                width: 100,
                child: FractionInput(
                  onChanged: (Fraction? value) {
                    if (value == null) return;
                    solution = value;
                  },
                  value:
                      solution.toDouble() != 0.0 ? solution.toString() : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool isAnswerCorrect() => solution == determinant.determinant();

  Matrix generateRandomDeterminant() {
    int size = 1 + ExerciseUtils.generateSize();
    return generateDeterminant(size);
  }

  Matrix generateDeterminant(int size) =>
      ExerciseUtils.generateMatrix(rows: size, columns: size);
}
