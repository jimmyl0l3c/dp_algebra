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

    // TODO: check if all vectors of Union(basisA, basisB) are same length

    // TODO: check if basisA.length == basisB.length

    // TODO: check if basis is basis (lin. independence)

    // List<Vector> solutions = [];
    // for (var v2 in basisB) {
    //   var solution = Matrix.fromVectors(
    //     List.from(basisA)..add(v2),
    //     vertical: true,
    //   ).solveByGauss();
    //   solutions.add(solution.toVectorList().first);
    // }
    // return Matrix.fromVectors(solutions);

    // TODO: implement simplify
    throw UnimplementedError();
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      'transformMatrix(${basisA.toTeX()}, ${basisB.toTeX()})';
}
