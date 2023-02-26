import 'package:dp_algebra/logic/general/tex_parsable.dart';
import 'package:dp_algebra/logic/matrix/matrix.dart';
import 'package:dp_algebra/logic/vector/vector.dart';
import 'package:dp_algebra/logic/vector/vector_operations.dart';

class VectorSolution implements TexParsable {
  final List<Vector> vectors;
  final List<Vector>? otherVectors;
  final Vector? inputVector;
  final VectorOperation operation;
  final dynamic solution;

  final Object? stepByStep;

  VectorSolution({
    required this.vectors,
    this.otherVectors,
    this.inputVector,
    required this.operation,
    required this.solution,
    this.stepByStep,
  });

  String toTeX() {
    StringBuffer buffer = StringBuffer();

    buffer.write('\\text{${operation.description} }\\big(');

    buffer.write(_vectorListToTeX(vectors));

    if (otherVectors != null) {
      buffer.write(', ${_vectorListToTeX(otherVectors!)}');
    }

    if (inputVector != null) {
      buffer.write(', ${inputVector!.toTeX()}');
    }

    buffer.write('\\big)=');

    switch (operation.solutionType) {
      case bool:
        buffer.write(solution ? r'\text{Ano}' : r'\text{Ne}');
        break;
      case List<Vector>:
        buffer.write(_vectorListToTeX(solution));
        break;
      case Matrix:
        buffer.write((solution as Matrix).toTeX());
        break;
      case Vector:
        buffer.write((solution as Vector).toTeX());
        break;
    }

    return buffer.toString();
  }

  String _vectorListToTeX(List<Vector> vectorList) {
    StringBuffer buffer = StringBuffer(r'\big\{');

    for (var i = 0; i < vectorList.length; i++) {
      buffer.write(vectorList[i].toTeX());

      if (i != (vectorList.length - 1)) {
        buffer.write(',');
      }
    }

    buffer.write(r'\big\}');
    return buffer.toString();
  }
}
