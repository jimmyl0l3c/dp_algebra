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
    // TODO: implement simplify
    throw UnimplementedError();
  }

  @override
  String toTeX() {
    // TODO: implement toTeX
    throw UnimplementedError();
  }
}
