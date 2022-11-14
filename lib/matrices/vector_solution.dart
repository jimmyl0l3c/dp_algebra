import 'package:dp_algebra/matrices/vector.dart';

class VectorSolution {
  final List<Vector> vectors;
  final VectorOperation operation;
  final dynamic solution;

  final Object? stepByStep;

  VectorSolution({
    required this.vectors,
    required this.operation,
    required this.solution,
    this.stepByStep,
  });
}

enum VectorOperation {
  linearIndependence(
    description: 'Lineárně nezávislé',
    solutionType: bool,
  );

  final String description;
  final Type solutionType;

  const VectorOperation({
    required this.description,
    required this.solutionType,
  });
}
