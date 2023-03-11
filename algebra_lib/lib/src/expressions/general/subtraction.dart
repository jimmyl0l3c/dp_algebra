import 'package:algebra_lib/algebra_lib.dart';

class Subtraction implements Expression {
  final Expression left;
  final Expression right;

  Subtraction({required this.left, required this.right});

  @override
  Expression simplify() {
    // If left can be simplified, do it
    if (left is! Vector && left is! Matrix && left is! Scalar) {
      return Subtraction(left: left.simplify(), right: right);
    }

    // If right can be simplified, do it
    if (right is! Vector && right is! Matrix && right is! Scalar) {
      return Subtraction(left: left, right: right.simplify());
    }

    if (left is Scalar && right is Scalar) {
      return Scalar(value: (left as Scalar).value - (right as Scalar).value);
    }

    if (left is Vector && right is Vector) {
      List<Expression> addedVector = [];
      Vector leftVector = left as Vector;
      Vector rightVector = right as Vector;

      if (leftVector.length() != rightVector.length()) {
        throw VectorSizeMismatchException();
      }

      for (var i = 0; i < leftVector.length(); i++) {
        addedVector.add(Subtraction(
          left: leftVector[i],
          right: rightVector[i],
        ));
      }

      return Vector(items: addedVector);
    }

    if (left is Matrix && right is Matrix) {
      List<List<Expression>> addedMatrix = [];
      Matrix leftMatrix = left as Matrix;
      Matrix rightMatrix = right as Matrix;

      if (leftMatrix.rowCount() != rightMatrix.rowCount() ||
          leftMatrix.columnCount() != rightMatrix.columnCount()) {
        throw MatrixSizeMismatchException();
      }

      for (var r = 0; r < leftMatrix.rowCount(); r++) {
        List<Expression> matrixRow = [];

        for (var c = 0; c < leftMatrix.columnCount(); c++) {
          matrixRow.add(Subtraction(
            left: leftMatrix[r][c],
            right: rightMatrix[r][c],
          ));
        }
        addedMatrix.add(matrixRow);
      }

      return Matrix(rows: addedMatrix);
    }

    throw UndefinedOperationException();
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    StringBuffer buffer = StringBuffer();

    buffer.write('\\begin{pmatrix} ${left.toTeX()} -');
    if (right is Scalar && (right as Scalar).value.isNegative) {
      buffer.write('(');
    }

    buffer.write(' ${right.toTeX()} ');

    if (right is Scalar && (right as Scalar).value.isNegative) {
      buffer.write(')');
    }
    buffer.write(' \\end{pmatrix}');

    return buffer.toString();
  }
}
