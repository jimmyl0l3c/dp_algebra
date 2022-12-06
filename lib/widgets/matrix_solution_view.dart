import 'package:dp_algebra/matrices/matrix_solution.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class SolutionView extends StatelessWidget {
  final MatrixSolution solution;

  const SolutionView({
    Key? key,
    required this.solution,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: optimize for large matrices (too wide equations)
    return Math.tex(
      solution.toTeX(),
      textScaleFactor: 1.4,
    );
    // return Wrap(
    //   direction: Axis.horizontal,
    //   children: [
    //     if (solution.operation.prependSymbol) Text(solution.operation.symbol),
    //     if (solution.operation.enclose) const Text('('),
    //     Text(solution.leftOp.toString()),
    //     if (solution.operation.enclose) const Text(')'),
    //     if (!solution.operation.prependSymbol) Text(solution.operation.symbol),
    //     if (solution.rightOp != null) Text(solution.rightOp.toString()),
    //     const Text('='),
    //     Text(solution.solution.toString()),
    //   ],
    // );
  }
}
