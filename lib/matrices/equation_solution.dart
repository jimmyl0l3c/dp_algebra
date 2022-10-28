import 'matrix.dart';

class EquationSolution {
  final Matrix equationMatrix;
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
    buffer.write(', ');
    buffer.write(solution.toTeX());

    return buffer.toString();
  }
}
