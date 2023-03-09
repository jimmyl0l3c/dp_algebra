import 'package:algebra_lib/algebra_lib.dart';

class VectorIndependence implements Expression {
  final List<Expression> vectors;

  VectorIndependence({required this.vectors});

  @override
  Expression simplify() {
    // After first simplify, return BoolExp(equation == zeroVector)

    // TODO: implement simplify
    throw UnimplementedError();
  }

  @override
  String toTeX() {
    // TODO: implement toTeX
    throw UnimplementedError();
  }
}
