import 'package:algebra_lib/algebra_lib.dart' as algebra;
import 'package:dp_algebra/logic/matrix/matrix.dart';

class TempUtil {
  // TODO: delete this after finishing migration to new Expressions
  static algebra.Matrix matrixExpFromMatrix(Matrix m) {
    List<List<algebra.Expression>> expMatrix = [];

    for (var r = 0; r < m.getRows(); r++) {
      List<algebra.Expression> expRow = [];
      for (var c = 0; c < m.getColumns(); c++) {
        expRow.add(algebra.Scalar(value: m[r][c]));
      }
      expMatrix.add(expRow);
    }

    return algebra.Matrix(rows: expMatrix);
  }
}
