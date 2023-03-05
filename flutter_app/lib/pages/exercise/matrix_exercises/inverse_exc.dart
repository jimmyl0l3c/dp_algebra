import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/logic/matrix/matrix_model.dart';
import 'package:dp_algebra/models/calc_result.dart';
import 'package:dp_algebra/pages/exercise/general/exercise_page.dart';
import 'package:dp_algebra/utils/exc_utils.dart';
import 'package:dp_algebra/utils/utils.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:dp_algebra/widgets/input/matrix_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class InverseMatrixExc extends StatefulWidget {
  const InverseMatrixExc({Key? key}) : super(key: key);

  @override
  State<InverseMatrixExc> createState() => _InverseMatrixExcState();
}

class _InverseMatrixExcState extends State<InverseMatrixExc> {
  MatrixModel matrix = MatrixModel(columns: 1, rows: 1);
  MatrixModel solution = MatrixModel(columns: 1, rows: 1);

  CalcResult? correctSolution;

  @override
  Widget build(BuildContext context) {
    return ExercisePage(
      generateButtons: [
        ButtonRowItem(
            child: const Text('Vygenerovat'),
            onPressed: () {
              setState(() {
                generateSquareMatrix(ExerciseUtils.generateSize());
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
    if (correctSolution == null) return false;
    return true;
  }

  bool isAnswerCorrect() => solution.toMatrix() == correctSolution?.result;

  void generateSquareMatrix(int size) {
    matrix = ExerciseUtils.generateMatrix(rows: size, columns: size);
    try {
      correctSolution = CalcResult.calculate(Inverse(exp: matrix.toMatrix()));
    } on Exception {
      correctSolution = null;
    }
  }
}
