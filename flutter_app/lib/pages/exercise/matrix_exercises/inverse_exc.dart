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
  MatrixModel solution = MatrixModel(columns: 1, rows: 1);

  late Expression exercise;
  CalcResult? correctSolution;

  @override
  void initState() {
    super.initState();
    generateSquareMatrix(3);
  }

  @override
  Widget build(BuildContext context) {
    return ExercisePage(
      generateButtons: [
        ButtonRowItem(
            child: const Text('Vygenerovat'),
            onPressed: () {
              setState(() {
                generateSquareMatrix(ExerciseUtils.generateSize(min: 2));
              });
            })
      ],
      example: Math.tex(
        '${exercise.toTeX()} =',
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

  bool inverseExists() => correctSolution != null;

  bool isAnswerCorrect() => solution.toMatrix() == correctSolution?.result;

  void generateSquareMatrix(int size) {
    var matrix = ExerciseUtils.generateSquareMatrix(size).toMatrix();
    exercise = Inverse(exp: matrix);

    try {
      correctSolution = CalcResult.calculate(exercise);
    } on ExpressionException {
      correctSolution = null;
    }
  }
}
