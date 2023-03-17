import 'package:algebra_lib/algebra_lib.dart';

class TransformCoords implements Expression {
  final Expression transformMatrix;
  final Expression coords;

  TransformCoords({required this.transformMatrix, required this.coords}) {
    if (transformMatrix is Scalar || transformMatrix is Vector) {
      throw UndefinedOperationException();
    }

    if (coords is Scalar || coords is Matrix) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (coords is Matrix || coords is Scalar) {
      throw UndefinedOperationException();
    }

    if (transformMatrix is Scalar || transformMatrix is Vector) {
      throw UndefinedOperationException();
    }

    if (coords is! Vector) {
      return TransformCoords(
        transformMatrix: transformMatrix,
        coords: coords.simplify(),
      );
    }

    if (transformMatrix is! Matrix) {
      return TransformCoords(
        transformMatrix: transformMatrix.simplify(),
        coords: coords,
      );
    }

    Matrix m = transformMatrix.simplify() as Matrix;
    // If the matrix contains non-computed expressions, return simplified
    if (m != transformMatrix) {
      return TransformCoords(transformMatrix: m, coords: coords);
    }

    Vector vectorCoords = coords as Vector;
    return Multiply(
      left: transformMatrix,
      right: Transpose(
        matrix: Matrix(
          rows: [vectorCoords],
          rowCount: 1,
          columnCount: vectorCoords.length(),
        ),
      ),
    );
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      'tramsformCoords(${transformMatrix.toTeX()}, ${coords.toTeX()})';
}
