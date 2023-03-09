import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/logic/matrix/matrix_model.dart';
import 'package:dp_algebra/logic/vector/vector_model.dart';

class TempUtil {
  // TODO: delete this after finishing migration to new Expressions
  static Matrix matrixFromMatrixModel(MatrixModel m) {
    List<List<Expression>> expMatrix = [];

    for (var r = 0; r < m.getRows(); r++) {
      List<Expression> expRow = [];
      for (var c = 0; c < m.getColumns(); c++) {
        expRow.add(Scalar(value: m[r][c]));
      }
      expMatrix.add(expRow);
    }

    return Matrix(rows: expMatrix);
  }

  static Vector vectorFromVectorModel(VectorModel v) {
    List<Expression> expVector = [];

    for (var i = 0; i < v.length(); i++) {
      expVector.add(Scalar(value: v[i]));
    }

    return Vector(items: expVector);
  }
}
