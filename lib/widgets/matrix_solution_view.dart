import 'package:flutter/material.dart';

import '../matrices/matrix.dart';
import '../matrices/solution.dart';

class SolutionView extends StatelessWidget {
  final Solution solution;
  final Map<String, Matrix> matrices;

  const SolutionView({
    Key? key,
    required this.solution,
    required this.matrices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        if (solution.operation.prependSymbol) Text(solution.operation.symbol),
        if (solution.operation.enclose) const Text('('),
        Text(solution.leftOp.toString()),
        if (solution.operation.enclose) const Text(')'),
        if (!solution.operation.prependSymbol) Text(solution.operation.symbol),
        if (solution.rightOp != null) Text(solution.rightOp.toString()),
        const Text('='),
        Text(solution.solution.toString()),
      ],
    );
  }
}
