import 'equation_matrix.dart';
import 'matrix.dart';

class EquationSolution {
  final EquationMatrix equationMatrix;
  final Matrix solution;
  final Object? stepByStep;

  EquationSolution({
    required this.equationMatrix,
    required this.solution,
    this.stepByStep,
  });

  String toTeX() {
    StringBuffer buffer = StringBuffer();

    buffer.write(r'(A\vert y^T)=');
    buffer.write(equationMatrix.toTeX());
    buffer.write(', x=');
    buffer.write(solution.toTeX());

    return buffer.toString();
  }
}
