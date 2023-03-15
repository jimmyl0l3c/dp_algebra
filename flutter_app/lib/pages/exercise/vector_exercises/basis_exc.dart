import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/models/calc/calc_result.dart';
import 'package:dp_algebra/models/input/vector_model.dart';
import 'package:dp_algebra/pages/exercise/general/exercise_page.dart';
import 'package:dp_algebra/utils/exc_utils.dart';
import 'package:dp_algebra/utils/utils.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:dp_algebra/widgets/input/vector_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class BasisExc extends StatefulWidget {
  const BasisExc({Key? key}) : super(key: key);

  @override
  State<BasisExc> createState() => _BasisExcState();
}

class _BasisExcState extends State<BasisExc> {
  List<VectorModel> vectors = [];
  List<VectorModel> solution = [];

  late CalcResult correctSolution;

  @override
  void initState() {
    super.initState();
    _generateBasis();
  }

  @override
  Widget build(BuildContext context) {
    return ExercisePage(
      generateButtons: [
        ButtonRowItem(
          child: const Text('Náhodně'),
          onPressed: () {
            setState(() {
              _generateBasis();
            });
          },
        ),
      ],
      example: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: vectors
            .map((v) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Math.tex(
                    v.toTeX(),
                    textScaleFactor: 1.4,
                  ),
                ))
            .toList(),
      ),
      result: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Řešení'),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    solution.add(VectorModel());
                  });
                },
                child: const Text('+'),
              ),
            ],
          ),
          for (var v in solution)
            VectorInput(
              vector: v,
              deleteVector: () {
                setState(() {
                  solution.remove(v);
                });
              },
            ),
        ],
      ),
      resolveButtons: [
        ButtonRowItem(
          child: const Text('Zkontrolovat'),
          onPressed: vectors.isEmpty
              ? null
              : () {
                  AlgebraUtils.showMessage(
                    context,
                    _isAnswerCorrect() ? 'Správně' : 'Špatně',
                  );
                },
        ),
        ButtonRowItem(
          child: const Text('Neexistuje'),
          onPressed: vectors.isEmpty
              ? null
              : () {
                  ExpressionSet solutionSet =
                      correctSolution.result as ExpressionSet;
                  AlgebraUtils.showMessage(
                    context,
                    solutionSet.items.isEmpty ? 'Správně' : 'Špatně',
                  );
                },
        ),
      ],
    );
  }

  void _generateBasis() {
    vectors.clear();
    int length = ExerciseUtils.generateSize(min: 2);

    for (var i = 0; i < ExerciseUtils.generateSize(min: 2, max: 3); i++) {
      vectors.add(ExerciseUtils.generateVector(length: length));
    }

    correctSolution = CalcResult.calculate(FindBasis(
      matrix: Matrix.fromVectors(vectors.map((v) => v.toVector()).toList()),
    ));
  }

  bool _isAnswerCorrect() {
    var solutionSet = ExpressionSet(
      items: solution.map((v) => v.toVector()).toSet(),
    );
    var correctSet = correctSolution.result as ExpressionSet;

    // TODO: fix the equality check
    print(correctSet.toTeX());
    print(solutionSet.toTeX());

    return solutionSet == correctSet;
  }
}
