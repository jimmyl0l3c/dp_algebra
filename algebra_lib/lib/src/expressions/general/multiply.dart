import 'package:algebra_lib/algebra_lib.dart';

class Multiply implements Expression {
  final Expression left;
  final Expression right;

  Multiply({required this.left, required this.right});

  @override
  Expression simplify() {
    // If left or right is zero, return zero
    Scalar zero = Scalar.zero();
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
      return Scalar((left as Scalar).value * (right as Scalar).value);
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
      List<Expression> multipliedMatrix = [];

      for (var row in (right as Matrix).rows) {
        multipliedMatrix.add(Multiply(left: left, right: row).simplify());
      }

      return Matrix(
        rows: multipliedMatrix,
        rowCount: (right as Matrix).rowCount,
        columnCount: (right as Matrix).columnCount,
      );
    }

    if (left is Matrix && right is Scalar) {
      List<Expression> multipliedMatrix = [];

      for (var row in (left as Matrix).rows) {
        multipliedMatrix.add(Multiply(left: row, right: right).simplify());
      }

      return Matrix(
        rows: multipliedMatrix,
        rowCount: (left as Matrix).rowCount,
        columnCount: (left as Matrix).columnCount,
      );
    }

    if (left is Matrix && right is Matrix) {
      Matrix leftMatrix = left as Matrix;
      Matrix rightMatrix = right as Matrix;

      int leftCols = leftMatrix.columnCount;
      int rightRows = rightMatrix.rowCount;

      if (leftCols != rightRows) throw MatrixMultiplySizeException();

      int leftRows = leftMatrix.rowCount;
      int rightCols = rightMatrix.columnCount;

      if (leftRows == 1 && rightCols == 1) {
        Expression item = Multiply(
          left: (leftMatrix[0] as Vector)[0],
          right: (rightMatrix[0] as Vector)[0],
        );

        for (var i = 1; i < leftCols; i++) {
          item = Addition(
            left: item,
            right: Multiply(
              left: (leftMatrix[0] as Vector)[i],
              right: (rightMatrix[i] as Vector)[0],
            ),
          );
        }

        return item;
      } else {
        List<Expression> multipliedMatrices = [];

        for (var ra = 0; ra < leftRows; ra++) {
          List<Expression> outputRow = [];
          for (var cb = 0; cb < rightCols; cb++) {
            outputRow.add(
              Multiply(
                left: Matrix(
                  rows: [leftMatrix[ra]],
                  rowCount: 1,
                  columnCount: (leftMatrix[ra] as Vector).length,
                ),
                right: Matrix(
                  rows: rightMatrix.rows
                      .map((row) => Vector(items: [(row as Vector)[cb]]))
                      .toList(),
                  rowCount: rightMatrix.rowCount,
                  columnCount: 1,
                ),
              ),
            );
          }
          multipliedMatrices.add(Vector(items: outputRow));
        }

        return Matrix(
          rows: multipliedMatrices,
          rowCount: leftRows,
          columnCount: rightCols,
        );
      }
    }

    throw UndefinedOperationException();
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    StringBuffer buffer = StringBuffer();
    if (left is Scalar && (left as Scalar).value.isNegative) {
      buffer.write('(');
    }
    buffer.write(left.toTeX());
    if (left is Scalar && (left as Scalar).value.isNegative) {
      buffer.write(')');
    }

    buffer.write(r'\cdot ');

    if (right is Scalar && (right as Scalar).value.isNegative) {
      buffer.write('(');
    }
    buffer.write(right.toTeX());
    if (right is Scalar && (right as Scalar).value.isNegative) {
      buffer.write(')');
    }

    return buffer.toString();
  }
}
