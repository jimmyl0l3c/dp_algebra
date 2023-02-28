import 'package:dp_algebra/logic/matrix/matrix.dart';
import 'package:dp_algebra/pages/exercise/general/exercise_page.dart';
import 'package:dp_algebra/utils/exc_utils.dart';
import 'package:dp_algebra/utils/utils.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:dp_algebra/widgets/input/matrix_input.dart';
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
    return ExercisePage(
      generateButtons: [
        ButtonRowItem(
            child: const Text('Vygenerovat'),
            onPressed: () {
              setState(() {
                matrix = generateSquareMatrix(ExerciseUtils.generateSize());
              });
            })
      ],
      example: Math.tex(
        '${matrix.toTeX()} =',
        textScaleFactor: 1.4,
      ),
      result: MatrixInput(matrix: solution),
      resolveButtons: [
        ButtonRowItem(
          child: const Text('Zkontrolovat'),
          onPressed: () {
            AlgebraUtils.showMessage(
                context, isAnswerCorrect() ? 'Správně' : 'Špatně');
          },
        ),
        ButtonRowItem(
          child: const Text('Nemá inverzní'),
          onPressed: () {
            AlgebraUtils.showMessage(
                context, inverseExists() ? 'Špatně' : 'Správně');
          },
        ),
      ],
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
