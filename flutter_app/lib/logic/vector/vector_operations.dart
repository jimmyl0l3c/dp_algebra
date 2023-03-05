import 'package:dp_algebra/logic/matrix/matrix_model.dart';
import 'package:dp_algebra/logic/vector/vector_model.dart';

enum VectorOperation {
  linearIndependence(
    description: 'Lineárně nezávislé',
    solutionType: bool,
  ),
  findBasis(
    description: 'Báze',
    solutionType: List<VectorModel>,
  ),
  transformMatrix(
    description: 'Transformační matice',
    solutionType: MatrixModel,
  ),
  transformCoordinates(
    description: 'Transformace souřadnic',
    solutionType: VectorModel,
  );

  final String description;
  final Type solutionType;

  const VectorOperation({
    required this.description,
    required this.solutionType,
  });
}
