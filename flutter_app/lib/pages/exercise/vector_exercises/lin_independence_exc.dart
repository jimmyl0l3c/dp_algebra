import 'dart:math';

import 'package:algebra_expressions/algebra_expressions.dart';
import 'package:big_fraction/big_fraction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../data/predefined_refs.dart';
import '../../../models/calc/calc_result.dart';
import '../../../models/input/vector_model.dart';
import '../../../utils/exc_utils.dart';
import '../../../utils/utils.dart';
import '../../../widgets/forms/button_row.dart';
import '../../generic/exercise_page.dart';

class LinIndependenceExc extends StatefulWidget {
  const LinIndependenceExc({super.key});

  @override
  State<LinIndependenceExc> createState() => _LinIndependenceExcState();
}

class _LinIndependenceExcState extends State<LinIndependenceExc> {
  final Random _random = Random();

  final List<VectorModel> vectors = [];

  bool isIndependent = false;
  late CalcResult correctSolution;

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
                  showSnackBarMessage(
                      context, isIndependent ? 'Špatně' : 'Správně');
                },
        ),
        ButtonRowItem(
          child: const Text('Lin. nezávislé'),
          onPressed: vectors.isEmpty
              ? null
              : () {
                  showSnackBarMessage(
                      context, isIndependent ? 'Správně' : 'Špatně');
                },
        ),
      ],
      solution: correctSolution,
      hintRef: PredefinedRef.vectorLinIndependence.refName,
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
        var cf = BigFraction.from(c);

        for (var i = 0; i < length; i++) {
          combined[i] += cf * vector[i];
        }
      }
      vectors.add(combined);
    }

    correctSolution = CalcResult.calculate(
      AreVectorsLinearlyIndependent(
        vectors: vectors.map((v) => v.toVector()).toList(),
      ),
    );
    isIndependent = correctSolution.result is Boolean &&
        (correctSolution.result as Boolean).value;
  }
}
