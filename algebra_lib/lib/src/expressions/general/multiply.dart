import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/matrix.dart';
import '../structures/parametrized_scalar.dart';
import '../structures/scalar.dart';
import '../structures/variable.dart';
import '../structures/vector.dart';
import 'addition.dart';

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
    var simplifiedLeft = left.simplify();
    if (left != simplifiedLeft) {
      return Multiply(left: simplifiedLeft, right: right);
    }

    // If right can be simplified, do it
    var simplifiedRight = right.simplify();
    if (right != simplifiedRight) {
      return Multiply(left: left, right: simplifiedRight);
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

    if (left is Scalar && right is ParametrizedScalar) {
      return ParametrizedScalar(
        values: (right as ParametrizedScalar)
            .values
            .map((e) => Multiply(
                  left: left,
                  right: e,
                ))
            .toList(),
      );
    }

    if (left is ParametrizedScalar && right is Scalar) {
      return ParametrizedScalar(
        values: (left as ParametrizedScalar)
            .values
            .map((e) => Multiply(
                  left: e,
                  right: right,
                ))
            .toList(),
      );
    }

    if (left is Scalar && right is Variable) {
      return Variable(
        n: Multiply(left: left, right: (right as Variable).n),
        param: (right as Variable).param,
      );
    }

    if (left is Variable && right is Scalar) {
      return Variable(
        n: Multiply(left: (left as Variable).n, right: right),
        param: (left as Variable).param,
      );
    }

    // TODO: Variable and Variable ?

    throw UndefinedOperationException();
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    StringBuffer buffer = StringBuffer();
    bool encloseLeft = (left is Scalar && (left as Scalar).value.isNegative) ||
        (left is ParametrizedScalar) ||
        (left is Variable);

    if (encloseLeft) {
      buffer.write('(');
    }
    buffer.write(left.toTeX());
    if (encloseLeft) {
      buffer.write(')');
    }

    buffer.write(r'\cdot ');

    bool encloseRight =
        (right is Scalar && (right as Scalar).value.isNegative) ||
            (right is ParametrizedScalar) ||
            (right is Variable);

    if (encloseRight) {
      buffer.write('(');
    }
    buffer.write(right.toTeX());
    if (encloseRight) {
      buffer.write(')');
    }

    return buffer.toString();
  }
}
