import 'dart:math';

import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/models/calc/calc_result.dart';
import 'package:dp_algebra/models/input/vector_model.dart';
import 'package:dp_algebra/pages/exercise/general/exercise_page.dart';
import 'package:dp_algebra/utils/exc_utils.dart';
import 'package:dp_algebra/utils/utils.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:fraction/fraction.dart';

class LinIndependenceExc extends StatefulWidget {
  const LinIndependenceExc({Key? key}) : super(key: key);

  @override
  State<LinIndependenceExc> createState() => _LinIndependenceExcState();
}

class _LinIndependenceExcState extends State<LinIndependenceExc> {
  List<VectorModel> vectors = [];
  bool isIndependent = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generateVectors();
  }

  @override
  Widget build(BuildContext context) {
    return ExercisePage(
      generateButtons: [
        ButtonRowItem(
          child: const Text('Náhodně'),
          onPressed: () {
            setState(() {
              _generateVectors();
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

  void _generateVectors() {
    bool ensureDependent = _random.nextBool();

    vectors.clear();
    int length = ExerciseUtils.generateSize(min: 2);

    for (var i = 0; i < ExerciseUtils.generateSize(min: 2, max: 3); i++) {
      if (ensureDependent && i == 0) continue;
      vectors.add(ExerciseUtils.generateVector(length: length));
    }

    if (ensureDependent) {
      VectorModel combined = VectorModel(length: length);
      for (var vector in vectors) {
        int c = _random.nextInt(2) + 2;
        if (_random.nextBool()) c *= -1;
        var cf = Fraction(c);

        for (var i = 0; i < length; i++) {
          combined[i] += cf * vector[i];
        }
      }
      vectors.add(combined);
    }

    var independence = CalcResult.calculate(AreVectorsLinearlyIndependent(
      vectors: vectors.map((v) => v.toVector()).toList(),
    ));
    isIndependent = independence.result is Boolean &&
        (independence.result as Boolean).value;
  }
}
