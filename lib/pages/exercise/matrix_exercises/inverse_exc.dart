import 'package:dp_algebra/matrices/matrix.dart';
import 'package:dp_algebra/pages/exercise/utils.dart';
import 'package:dp_algebra/widgets/button_row.dart';
import 'package:dp_algebra/widgets/matrix_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:fraction/fraction.dart';

class InverseMatrixExc extends StatefulWidget {
  const InverseMatrixExc({Key? key}) : super(key: key);

  @override
  State<InverseMatrixExc> createState() => _InverseMatrixExcState();
}

class _InverseMatrixExcState extends State<InverseMatrixExc> {
  Matrix matrix = Matrix(columns: 1, rows: 1);
  Matrix solution = Matrix(columns: 1, rows: 1);

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
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    matrix = generateSquareMatrix(ExerciseUtils.generateSize());
                  });
                },
                child: const Text('Náhodně'),
              ),
              const VerticalDivider(),
              ButtonRow(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                children: [
                  ButtonRowItem(
                    child: const Text('Zkontrolovat'),
                    onPressed: () {
                      ExerciseUtils.showError(
                          context, isAnswerCorrect() ? 'Správně' : 'Špatně');
                    },
                  ),
                  ButtonRowItem(
                    child: const Text('Nemá inverzní'),
                    onPressed: () {
                      ExerciseUtils.showError(
                          context, inverseExists() ? 'Špatně' : 'Správně');
                    },
                  ),
                ],
              ),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.horizontal,
            children: [
              Math.tex(
                '${matrix.toTeX()} =',
                textScaleFactor: 1.4,
              ),
              MatrixInput(matrix: solution),
            ],
          ),
        ],
      ),
    );
  }

  bool inverseExists() {
    if (!matrix.isSquare()) return false;
    if (matrix.determinant() == Fraction(0)) return false;
    return true;
  }

  bool isAnswerCorrect() {
    Matrix? correctSolution;
    try {
      correctSolution = matrix.inverse();
      return correctSolution == solution;
    } on Exception {
      return false;
    }
  }

  Matrix generateSquareMatrix(int size) =>
      ExerciseUtils.generateMatrix(rows: size, columns: size);
}
