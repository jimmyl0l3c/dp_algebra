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

    if (coords is! Vector) {
      return TransformCoords(
        transformMatrix: transformMatrix,
        coords: coords.simplify(),
      );
    }

    Vector vectorCoords = coords as Vector;
    return Multiply(
      left: transformMatrix,
      right: Transpose(
        matrix: Matrix(rows: [vectorCoords.items]),
      ),
    );
  }

  @override
  String toTeX() =>
      'tramsformCoords(${transformMatrix.toTeX()}, ${coords.toTeX()})';
}
