import 'package:algebra_lib/algebra_lib.dart';
import 'package:fraction/fraction.dart';

class Multiply implements Expression {
  final Expression left;
  final Expression right;

  Multiply({required this.left, required this.right});

  @override
  Expression simplify() {
    // If left or right is zero, return zero
    Scalar zero = Scalar(value: Fraction(0));
    if (left is Scalar && left == zero) {
      return zero;
    }
    if (right is Scalar && right == zero) {
      return zero;
    }

    // If left can be simplified, do it
    if (left is! Vector && left is! Matrix && left is! Scalar) {
      return Multiply(left: left.simplify(), right: right);
    }

    // If right can be simplified, do it
    if (right is! Vector && right is! Matrix && right is! Scalar) {
      return Multiply(left: left, right: right.simplify());
    }

    if (left is Scalar && right is Scalar) {
      return Scalar(value: (left as Scalar).value * (right as Scalar).value);
    }

    if (left is Scalar && right is Vector) {
      List<Expression> multipliedVector = [];

      for (var item in (right as Vector).items) {
        multipliedVector.add(Multiply(left: left, right: item));
      }

      return Vector(items: multipliedVector);
    }

    if (left is Vector && right is Scalar) {
      List<Expression> multipliedVector = [];

      for (var item in (left as Vector).items) {
        multipliedVector.add(Multiply(left: item, right: right));
      }

      return Vector(items: multipliedVector);
    }

    if (left is Scalar && right is Matrix) {
      List<List<Expression>> multipliedMatrix = [];

      for (var row in (right as Matrix).rows) {
        List<Expression> multipliedRow = [];

        for (var col in row) {
          multipliedRow.add(Multiply(left: left, right: col));
        }

        multipliedMatrix.add(multipliedRow);
      }

      return Matrix(rows: multipliedMatrix);
    }

    if (left is Matrix && right is Scalar) {
      List<List<Expression>> multipliedMatrix = [];

      for (var row in (left as Matrix).rows) {
        List<Expression> multipliedRow = [];

        for (var col in row) {
          multipliedRow.add(Multiply(left: col, right: right));
        }

        multipliedMatrix.add(multipliedRow);
      }

      return Matrix(rows: multipliedMatrix);
    }

    if (left is Matrix && right is Matrix) {
      Matrix leftMatrix = left as Matrix;
      Matrix rightMatrix = right as Matrix;

      int leftCols = leftMatrix.columnCount();
      int rightRows = rightMatrix.rowCount();

      if (leftCols != rightRows) throw MatrixMultiplySizeException();

      int leftRows = leftMatrix.rowCount();
      int rightCols = rightMatrix.columnCount();

      if (leftRows == 1 && rightCols == 1) {
        Expression item = Multiply(
          left: leftMatrix.rows.first.first,
          right: rightMatrix.rows.first.first,
        );

        for (var i = 1; i < leftCols; i++) {
          item = Addition(
            left: item,
            right: Multiply(
              left: leftMatrix.rows.first[i],
              right: rightMatrix.rows[i].first,
            ),
          );
        }

        return item;
      } else {
        List<List<Expression>> multipliedMatrices = [];

        for (var ra = 0; ra < leftRows; ra++) {
          List<Expression> outputRow = [];
          for (var cb = 0; cb < rightCols; cb++) {
            outputRow.add(
              Multiply(
                left: Matrix(
                  rows: [leftMatrix.rows[ra]],
                ),
                right: Matrix(
                  rows: rightMatrix.rows.map((row) => [row[cb]]).toList(),
                ),
              ),
            );
          }
          multipliedMatrices.add(outputRow);
        }

        return Matrix(rows: multipliedMatrices);
      }
    }

    throw UndefinedOperationException();
  }

  @override
  String toTeX() => '(${left.toTeX()} \\cdot ${right.toTeX()})';
}
