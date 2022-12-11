import 'package:dp_algebra/logic/matrix/matrix.dart';
import 'package:dp_algebra/logic/vector/vector.dart';

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
