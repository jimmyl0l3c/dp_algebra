import 'package:dp_algebra/logic/vector/vector_model.dart';
import 'package:dp_algebra/pages/exercise/general/exercise_page.dart';
import 'package:dp_algebra/utils/exc_utils.dart';
import 'package:dp_algebra/utils/utils.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class LinIndependenceExc extends StatefulWidget {
  const LinIndependenceExc({Key? key}) : super(key: key);

  @override
  State<LinIndependenceExc> createState() => _LinIndependenceExcState();
}

class _LinIndependenceExcState extends State<LinIndependenceExc> {
  List<VectorModel> vectors = [];
  bool isIndependent = false;

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

              // TODO: implement
              // isIndependent = VectorModel.areLinearlyIndependent(vectors);
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
      resolveButtons: [
        ButtonRowItem(
          child: const Text('Lin. závislé'),
          onPressed: vectors.isEmpty
              ? null
              : () {
                  AlgebraUtils.showMessage(
                      context, isIndependent ? 'Špatně' : 'Správně');
                },
        ),
        ButtonRowItem(
          child: const Text('Lin. nezávislé'),
          onPressed: vectors.isEmpty
              ? null
              : () {
                  AlgebraUtils.showMessage(
                      context, isIndependent ? 'Správně' : 'Špatně');
                },
        ),
      ],
    );
  }
}
