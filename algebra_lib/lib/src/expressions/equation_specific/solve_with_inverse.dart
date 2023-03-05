import 'package:algebra_lib/algebra_lib.dart';

class SolveWithInverse implements Expression {
  final Expression matrix;
  final Expression vectorY;

  SolveWithInverse({required this.matrix, required this.vectorY}) {
    if (matrix is Scalar) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (matrix is Scalar) {
      throw UndefinedOperationException();
    }

    // If left can be simplified, do it
    if (matrix is! Vector && matrix is! Matrix) {
      return SolveWithInverse(matrix: matrix.simplify(), vectorY: vectorY);
    }

    // If left can be simplified, do it
    if (vectorY is! Vector && vectorY is! Matrix && vectorY is! Scalar) {
      return SolveWithInverse(matrix: matrix, vectorY: vectorY.simplify());
    }

    Matrix m = matrix is Vector
        ? Matrix(rows: [(matrix as Vector).items])
        : matrix as Matrix;

    Matrix y = vectorY is Vector
        ? Matrix(rows: [(vectorY as Vector).items])
        : vectorY as Matrix;

    return Transpose(
      matrix: Multiply(left: Inverse(exp: m), right: Transpose(matrix: y)),
    );
  }

  @override
  String toTeX() {
    StringBuffer buffer = StringBuffer();
    buffer.write(r'\left( \begin{matrix} ');

    buffer.write(matrix.toTeX());

    buffer.write(r'\end{matrix} \middle\vert \, \begin{matrix} ');

    buffer.write(vectorY.toTeX());

    buffer.write(r'\end{matrix} \right)');
    return buffer.toString();
  }
}
