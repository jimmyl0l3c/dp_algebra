import 'package:algebra_lib/algebra_lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../models/calc/calc_expression_exception.dart';
import '../../../models/calc/calc_result.dart';
import '../../../models/input/matrix_model.dart';
import '../../../utils/exc_utils.dart';
import '../../../utils/utils.dart';
import '../../../widgets/forms/button_row.dart';
import '../../../widgets/input/matrix_input.dart';
import '../general/exercise_page.dart';

class InverseMatrixExc extends StatefulWidget {
  const InverseMatrixExc({Key? key}) : super(key: key);

  @override
  State<InverseMatrixExc> createState() => _InverseMatrixExcState();
}

class _InverseMatrixExcState extends State<InverseMatrixExc> {
  final MatrixModel solution = MatrixModel(columns: 1, rows: 1);

  late Expression exercise;
  CalcResult? correctSolution;
  String? strSolution;

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
            showSnackBarMessage(
                context, isAnswerCorrect() ? 'Správně' : 'Špatně');
          },
        ),
        ButtonRowItem(
          child: const Text('Nemá inverzní'),
          onPressed: () {
            showSnackBarMessage(
                context, inverseExists() ? 'Špatně' : 'Správně');
          },
        ),
      ],
      solution: correctSolution,
      strSolution: strSolution,
    );
  }

  bool inverseExists() => correctSolution != null;

  bool isAnswerCorrect() => solution.toMatrix() == correctSolution?.result;

  void generateSquareMatrix(int size) {
    var matrix = ExerciseUtils.generateSquareMatrix(size).toMatrix();
    exercise = Inverse(exp: matrix);

    try {
      correctSolution = CalcResult.calculate(exercise);
      strSolution = null;
    } on CalcExpressionException {
      correctSolution = CalcResult.calculate(Determinant(det: matrix));
      strSolution = "Inverzní matice k zadané matici neexistuje";
    }
  }
}
