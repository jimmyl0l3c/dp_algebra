import 'package:dp_algebra/logic/vector/vector.dart';
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
  List<Vector> vectors = [];
  List<Vector> solution = [];

  @override
  Widget build(BuildContext context) {
    return ExercisePage(
      generateButtons: [
        ButtonRowItem(
          child: const Text('Náhodně'),
          onPressed: () {
            setState(() {
              // TODO: change vectors generation
              vectors.clear();
              int length = ExerciseUtils.generateSize(min: 2);

              for (var i = 0;
                  i < ExerciseUtils.generateSize(min: 2, max: 3);
                  i++) {
                vectors.add(ExerciseUtils.generateVector(length: length));
              }
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
                    solution.add(Vector());
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
                  AlgebraUtils.showError(
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
                  List<Vector> correctSolution = Vector.findBasis(vectors);
                  AlgebraUtils.showError(
                    context,
                    correctSolution.isEmpty ? 'Správně' : 'Špatně',
                  );
                },
        ),
      ],
    );
  }

  bool _isAnswerCorrect() {
    List<Vector> correctSolution = Vector.findBasis(vectors);
    if (solution.length != correctSolution.length) return false;

    for (var vector in correctSolution) {
      if (!solution.contains(vector)) return false;
    }

    return true;
  }
}
