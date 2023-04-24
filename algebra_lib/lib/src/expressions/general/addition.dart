import 'package:collection/collection.dart';

import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/matrix.dart';
import '../structures/polynomial.dart';
import '../structures/scalar.dart';
import '../structures/variable.dart';
import '../structures/vector.dart';

class Addition implements Expression {
  final Expression left;
  final Expression right;

  Addition({required this.left, required this.right});

  @override
  Expression simplify() {
    // If left can be simplified, do it
    var simplifiedLeft = left.simplify();
    if (left != simplifiedLeft) {
      return Addition(left: simplifiedLeft, right: right);
    }

    // If right can be simplified, do it
    var simplifiedRight = right.simplify();
    if (right != simplifiedRight) {
      return Addition(left: left, right: simplifiedRight);
    }

    if (left is Scalar && right is Scalar) {
      return Scalar((left as Scalar).value + (right as Scalar).value);
    }

    if (left is Vector && right is Vector) {
      List<Expression> addedVector = [];
      Vector leftVector = left as Vector;
      Vector rightVector = right as Vector;

      if (leftVector.length != rightVector.length) {
        throw VectorSizeMismatchException();
      }

      for (var i = 0; i < leftVector.length; i++) {
        addedVector.add(Addition(
          left: leftVector[i],
          right: rightVector[i],
        ));
      }

      return Vector(items: addedVector);
    }

    if (left is Matrix && right is Matrix) {
      List<Expression> addedMatrix = [];
      Matrix leftMatrix = left as Matrix;
      Matrix rightMatrix = right as Matrix;

      if (leftMatrix.rowCount != rightMatrix.rowCount ||
          leftMatrix.columnCount != rightMatrix.columnCount) {
        throw MatrixSizeMismatchException();
      }

      for (var r = 0; r < leftMatrix.rowCount; r++) {
        List<Expression> matrixRow = [];

        for (var c = 0; c < leftMatrix.columnCount; c++) {
          matrixRow.add(Addition(
            left: (leftMatrix[r] as Vector)[c],
            right: (rightMatrix[r] as Vector)[c],
          ));
        }
        addedMatrix.add(Vector(items: matrixRow));
      }

      return Matrix(
        rows: addedMatrix,
        rowCount: leftMatrix.rowCount,
        columnCount: leftMatrix.columnCount,
      );
    }

    if (left is Polynomial && right is Polynomial) {
      List<Expression> result = [];
      Set<int> resolved = {};

      for (var item in (left as Polynomial).values) {
        if (item is Scalar) {
          var rightScalar =
              (right as Polynomial).values.firstWhereOrNull((e) => e is Scalar);
          result.add(
            rightScalar == null
                ? item
                : Addition(left: item, right: rightScalar),
          );
          resolved.add(-1);
        } else {
          var itemVar = item as Variable;
          var rightVar = (right as Polynomial).values.firstWhereOrNull(
              (e) => e is Variable && e.param == itemVar.param);
          result.add(
            rightVar == null
                ? item
                : Variable(
                    n: Addition(
                      left: itemVar.n,
                      right: (rightVar as Variable).n,
                    ),
                    param: itemVar.param,
                  ),
          );
          resolved.add(itemVar.param);
        }
      }

      for (var item in (right as Polynomial).values) {
        if ((item is Scalar && !resolved.contains(-1)) ||
            (item is Variable && !resolved.contains(item.param))) {
          result.add(item);
        }
      }
      return Polynomial(values: result);
    }

    if (left is Polynomial && right is Scalar) {
      Polynomial poly = left as Polynomial;
      int i = poly.values.indexWhere((e) => e is Scalar);
      if (i < 0) {
        return Polynomial(
          values: List.from(poly.values)..add(right),
        );
      } else {
        var scalarValue = poly.values[i];
        return Polynomial(
          values: List.from(poly.values)
            ..removeAt(i)
            ..add(Addition(left: scalarValue, right: right)),
        );
      }
    }

    if (left is Scalar && right is Polynomial) {
      Polynomial poly = right as Polynomial;
      int i = poly.values.indexWhere((e) => e is Scalar);
      if (i < 0) {
        return Polynomial(
          values: List.from(poly.values)..add(left),
        );
      } else {
        var scalarValue = poly.values[i];
        return Polynomial(
          values: List.from(poly.values)
            ..removeAt(i)
            ..add(Addition(left: left, right: scalarValue)),
        );
      }
    }

    throw UndefinedOperationException();
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    StringBuffer buffer = StringBuffer();

    if (flags == null || !flags.contains(TexFlags.dontEnclose)) {
      buffer.write(r'\left(');
    }
    buffer.write('${left.toTeX()} ');
    if (right is! Scalar || !(right as Scalar).value.isNegative) {
      buffer.write('+');
    }
    buffer.write(' ${right.toTeX()}');
    if (flags == null || !flags.contains(TexFlags.dontEnclose)) {
      buffer.write(r'\right)');
    }

    return buffer.toString();
  }
}
