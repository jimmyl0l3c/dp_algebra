import 'package:dp_algebra/logic/matrix/matrix.dart';
import 'package:dp_algebra/logic/vector/vector.dart';
import 'package:dp_algebra/pages/exercise/general/exercise_page.dart';
import 'package:dp_algebra/utils/utils.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:dp_algebra/widgets/input/matrix_input.dart';
import 'package:flutter/material.dart';

class TransformMatrixExc extends StatefulWidget {
  const TransformMatrixExc({Key? key}) : super(key: key);

  @override
  State<TransformMatrixExc> createState() => _TransformMatrixExcState();
}

class _TransformMatrixExcState extends State<TransformMatrixExc> {
  List<Vector> basisA = [];
  List<Vector> basisB = [];

  Matrix answer = Matrix();

  @override
  Widget build(BuildContext context) {
    return ExercisePage(
      generateButtons: [
        ButtonRowItem(
          child: const Text('Náhodně'),
        ),
      ],
      example: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // vectors
          //     .map((v) => Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 4.0),
          //   child: Math.tex(
          //     v.toTeX(),
          //     textScaleFactor: 1.4,
          //   ),
          // ))
          //     .toList()
        ],
      ),
      result: MatrixInput(matrix: answer),
      resolveButtons: [
        ButtonRowItem(
          child: const Text('Zkontrolovat'),
          onPressed: basisA.isEmpty || basisB.isEmpty
              ? null
              : () {
                  Matrix solution = Vector.getTransformMatrix(basisA, basisB);
                  AlgebraUtils.showError(
                    context,
                    solution == answer ? 'Správně' : 'Špatně',
                  );
                },
        ),
      ],
    );
  }
}
