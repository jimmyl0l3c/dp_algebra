import 'package:algebra_lib/algebra_lib.dart';

class IsSolvable implements Expression {
  final Expression matrix;
  final Expression vectorY;

  IsSolvable({required this.matrix, required this.vectorY});

  @override
  Expression simplify() {
    if (matrix is Scalar || matrix is Vector) {
      throw UndefinedOperationException();
    }
    if (vectorY is Scalar || vectorY is Matrix) {
      throw UndefinedOperationException();
    }

    if (matrix is! Matrix) {
      return IsSolvable(matrix: matrix.simplify(), vectorY: vectorY);
    }
    if (vectorY is! Vector) {
      return IsSolvable(matrix: matrix, vectorY: vectorY.simplify());
    }

    return AreEqual(
      left: Rank(matrix: matrix),
      right: Rank(
        matrix: Matrix.toEquationMatrix(matrix as Matrix, vectorY as Vector),
      ),
    );
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    StringBuffer buffer = StringBuffer('isSolvable');
    buffer.write(r'\left( \begin{matrix} ');

    buffer.write(matrix.toTeX());

    buffer.write(r'\end{matrix} \middle\vert \, \begin{matrix} ');

    buffer.write(vectorY.toTeX());

    buffer.write(r'\end{matrix} \right)');
    return buffer.toString();
  }
}
