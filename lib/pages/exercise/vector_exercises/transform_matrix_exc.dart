import 'package:dp_algebra/logic/vector/vector.dart';
import 'package:dp_algebra/pages/exercise/general/exercise_page.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class TransformMatrixExc extends StatefulWidget {
  const TransformMatrixExc({Key? key}) : super(key: key);

  @override
  State<TransformMatrixExc> createState() => _TransformMatrixExcState();
}

class _TransformMatrixExcState extends State<TransformMatrixExc> {
  List<Vector> vectors = [];

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
          child: const Text('Zkontrolovat'),
        ),
      ],
    );
  }
}
