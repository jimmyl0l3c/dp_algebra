import 'package:dp_algebra/matrices/matrix.dart';
import 'package:dp_algebra/matrices/vector.dart';

class VectorSolution {
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

enum VectorOperation {
  linearIndependence(
    description: 'Lineárně nezávislé',
    solutionType: bool,
  ),
  findBasis(
    description: 'Báze',
    solutionType: List<Vector>,
  ),
  transformMatrix(
    description: 'Transformační matice',
    solutionType: Matrix,
  ),
  transformCoordinates(
    description: 'Transformace souřadnic',
    solutionType: Vector,
  );

  final String description;
  final Type solutionType;

  const VectorOperation({
    required this.description,
    required this.solutionType,
  });
}
