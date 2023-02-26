import 'package:dp_algebra/logic/matrix/matrix.dart';
import 'package:dp_algebra/logic/vector/vector.dart';
import 'package:dp_algebra/pages/exercise/general/exercise_page.dart';
import 'package:dp_algebra/utils/exc_utils.dart';
import 'package:dp_algebra/utils/utils.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:dp_algebra/widgets/input/matrix_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

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
            onPressed: () {
              setState(() {
                basisA.clear();
                basisB.clear();

                int vectorLength = ExerciseUtils.generateSize(min: 2);
                int vectorCount = ExerciseUtils.generateSize(min: 2);

                // TODO: make sure they are linearly independent
                for (var i = 0; i < vectorCount; i++) {
                  basisA.add(
                    ExerciseUtils.generateVector(length: vectorLength),
                  );
                  basisB.add(
                    ExerciseUtils.generateVector(length: vectorLength),
                  );
                }
              });
            }),
      ],
      example: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // TODO: change how it is shown
          if (basisA.isNotEmpty) const Text('Basis A'),
          for (var v in basisA)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Math.tex(
                v.toTeX(),
                textScaleFactor: 1.4,
              ),
            ),
          if (basisB.isNotEmpty) const Text('Basis B'),
          for (var v in basisB)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Math.tex(
                v.toTeX(),
                textScaleFactor: 1.4,
              ),
            ),
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
