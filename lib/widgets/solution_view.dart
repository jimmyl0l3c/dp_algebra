import 'package:dp_algebra/matrices/tex_parsable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class SolutionView extends StatelessWidget {
  final TexParsable solution;

  const SolutionView({
    Key? key,
    required this.solution,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        runSpacing: 12.0,
        children: Math.tex(
          solution.toTeX(),
          textScaleFactor: 1.4,
        ).texBreak().parts,
      ),
    );
  }
}
