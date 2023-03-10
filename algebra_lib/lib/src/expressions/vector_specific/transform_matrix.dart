import 'package:algebra_lib/algebra_lib.dart';

class TransformMatrix implements Expression {
  final Expression basisA;
  final Expression basisB;

  TransformMatrix({required this.basisA, required this.basisB}) {
    if (basisA is Vector ||
        basisA is Scalar ||
        basisB is Vector ||
        basisB is Scalar) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (basisA is Vector ||
        basisA is Scalar ||
        basisB is Vector ||
        basisB is Scalar) {
      throw UndefinedOperationException();
    }

    // TODO: implement simplify
    throw UnimplementedError();
  }

  @override
  String toTeX() => 'transformMatrix(${basisA.toTeX()}, ${basisB.toTeX()})';
}
