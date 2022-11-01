import 'equation_matrix.dart';
import 'matrix.dart';

class EquationSolution {
  final EquationMatrix equationMatrix;
  final Matrix? solution;
  final GeneralSolution? generalSolution;
  final Object? stepByStep;

  EquationSolution({
    required this.equationMatrix,
    this.solution,
    this.generalSolution,
    this.stepByStep,
  });

  String toTeX() {
    StringBuffer buffer = StringBuffer();

    buffer.write(r'(A\vert y^T)=');
    buffer.write(equationMatrix.toTeX());
    buffer.write(', x=');
    if (solution != null) {
      buffer.write(solution?.toTeX());
    } else if (generalSolution != null) {
      buffer.write(generalSolution?.toTeX());
    } else {
      buffer.write('()');
    }

    return buffer.toString();
  }
}
