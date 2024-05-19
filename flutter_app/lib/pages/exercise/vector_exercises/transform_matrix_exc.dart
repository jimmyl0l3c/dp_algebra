import 'package:algebra_lib/algebra_lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../data/predefined_refs.dart';
import '../../../models/calc/calc_result.dart';
import '../../../models/input/matrix_model.dart';
import '../../../models/input/vector_model.dart';
import '../../../utils/exc_utils.dart';
import '../../../utils/utils.dart';
import '../../../widgets/forms/button_row.dart';
import '../../../widgets/input/matrix_input.dart';
import '../../generic/exercise_page.dart';

class TransformMatrixExc extends StatefulWidget {
  const TransformMatrixExc({super.key});

  @override
  State<TransformMatrixExc> createState() => _TransformMatrixExcState();
}

class _TransformMatrixExcState extends State<TransformMatrixExc> {
  final List<VectorModel> basisA = [];
  final List<VectorModel> basisB = [];

  final MatrixModel solution = MatrixModel();
  late CalcResult correctSolution;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  @override
  Widget build(BuildContext context) {
    return ExercisePage(
      generateButtons: [
        ButtonRowItem(
            child: const Text('Náhodně'),
            onPressed: () {
              setState(() {
                _generate();
              });
            }),
      ],
      example: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (basisA.isNotEmpty && basisB.isNotEmpty)
            const Text('Vytvořte matici přechodu od báze A k bázi B:'),
          const SizedBox(height: 12),
          if (basisA.isNotEmpty) const Text('Báze A'),
          for (var v in basisA)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Math.tex(
                v.toTeX(),
                textScaleFactor: 1.4,
              ),
            ),
          if (basisB.isNotEmpty) const Text('Báze B'),
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
      result: MatrixInput(matrix: solution),
      resolveButtons: [
        ButtonRowItem(
          child: const Text('Zkontrolovat'),
          onPressed: basisA.isEmpty || basisB.isEmpty
              ? null
              : () {
                  showSnackBarMessage(
                    context,
                    solution.toMatrix() == correctSolution.result
                        ? 'Správně'
                        : 'Špatně',
                  );
                },
        ),
      ],
      solution: correctSolution,
      hintRef: PredefinedRef.transformMatrix.refName,
    );
  }

  void _generate() {
    solution.clear();
    basisA.clear();
    basisB.clear();

    while (true) {
      try {
        int vectorCount = ExerciseUtils.generateSize(min: 2, max: 3);
        int vectorLength = ExerciseUtils.generateSize(min: vectorCount);

        var basisA = ExerciseUtils.generateBasis(
          vectorLength: vectorLength,
          basisLength: vectorCount,
        );

        var basisB = ExerciseUtils.generateBasis(
          vectorLength: vectorLength,
          basisLength: vectorCount,
        );

        correctSolution = CalcResult.calculate(TransformMatrix(
          basisA: ExpressionSet(items: basisA.map((v) => v.toVector()).toSet()),
          basisB: ExpressionSet(items: basisB.map((v) => v.toVector()).toSet()),
        ));

        this.basisA.addAll(basisA);
        this.basisB.addAll(basisB);

        break;
      } on Exception {
        // TODO: Add a fallback for the case when unable to generate for too long
      }
    }
  }
}
