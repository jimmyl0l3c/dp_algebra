import 'dart:math';

import 'package:algebra_expressions/algebra_expressions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../data/predefined_refs.dart';
import '../../../models/calc/calc_result.dart';
import '../../../utils/exc_utils.dart';
import '../../../utils/utils.dart';
import '../../../widgets/forms/button_row.dart';
import '../../generic/exercise_page.dart';

class HomomorphismsExc extends StatefulWidget {
  const HomomorphismsExc({super.key});

  @override
  State<HomomorphismsExc> createState() => _HomomorphismsExcState();
}

class _HomomorphismsExcState extends State<HomomorphismsExc> {
  final Random _random = Random();

  String exampleTeX = '';
  bool isHomomorphism = false;
  late CalcResult correctSolution;

  @override
  void initState() {
    super.initState();
    _generateExample();
  }

  @override
  Widget build(BuildContext context) {
    return ExercisePage(
      generateButtons: [
        ButtonRowItem(
          child: const Text('Náhodně'),
          onPressed: () {
            setState(() {
              _generateExample();
            });
          },
        ),
      ],
      example: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Jedná se o homomorfismus?'),
          const SizedBox(height: 12),
          Math.tex(exampleTeX, textScaleFactor: 1.4),
        ],
      ),
      resolveButtons: [
        ButtonRowItem(
          child: const Text('Ano'),
          onPressed: () {
            showSnackBarMessage(context, isHomomorphism ? 'Správně' : 'Špatně');
          },
        ),
        ButtonRowItem(
          child: const Text('Ne'),
          onPressed: () {
            showSnackBarMessage(context, isHomomorphism ? 'Špatně' : 'Správně');
          },
        ),
      ],
      solution: correctSolution,
      hintRef: PredefinedRef.basis.refName,
    );
  }

  void _generateExample() {
    int inputNum = _random.nextInt(3) + 1;
    int outNum = _random.nextInt(2) + inputNum;

    var mappingVector = Vector(items: [
      for (var i = 0; i < outNum; i++) _randomMappingItem(inputNum),
    ]);

    correctSolution = CalcResult.calculate(IsHomomorphism(
      inputVarCount: inputNum,
      mappingVector: mappingVector,
    ));
    isHomomorphism = (correctSolution.result as Boolean).value;

    var inputVector = Vector(items: [
      for (var i = 0; i < inputNum; i++) Variable(index: i),
    ]);
    exampleTeX = '${inputVector.toTeX()}\\to ${mappingVector.toTeX()}';
  }

  Expression _randomMappingItem(int inputNum) {
    int groupLen = _random.nextInt(inputNum) + 1;
    bool includeScalar = _random.nextBool();

    List<Expression> groupItems = [
      if (includeScalar) ExerciseUtils.generateNonZeroScalar(nonOneValue: true),
    ];

    if (includeScalar) {
      groupLen--;
    }

    for (var i = 0; i < groupLen; i++) {
      if (_random.nextBool()) {
        groupItems.add(_generateRandomMultiplyGroup(inputNum));
      } else {
        groupItems.add(Variable(index: _random.nextInt(inputNum)));
      }
    }

    Expression item = groupItems.length == 1
        ? groupItems.first
        : CommutativeGroup.add(groupItems);
    Expression simplifiedItem = item;

    do {
      item = simplifiedItem;
      simplifiedItem = item.simplify();
    } while (item != simplifiedItem);

    return item;
  }

  Expression _generateRandomMultiplyGroup(int inputNum) {
    int groupLen = _random.nextInt(inputNum) + 1;
    Expression group = CommutativeGroup.multiply([
      for (var i = 0; i < groupLen; i++)
        _generateSimpleItem(inputNum, nonOne: true),
    ]);

    return group;
  }

  Expression _generateSimpleItem(int inputNum, {bool nonOne = false}) {
    if (_random.nextBool()) {
      return ExerciseUtils.generateNonZeroScalar(nonOneValue: nonOne);
    } else {
      return Variable(index: _random.nextInt(inputNum));
    }
  }
}
