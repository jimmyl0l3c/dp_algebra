import 'package:dp_algebra/logic/general/extensions.dart';
import 'package:dp_algebra/logic/matrix/matrix_model.dart';
import 'package:dp_algebra/logic/vector/vector_model.dart';

class EquationMatrix extends MatrixModel {
  EquationMatrix({int columns = 1, int rows = 1, int defaultValue = 0})
      : super(columns: columns, rows: rows, defaultValue: defaultValue);

  EquationMatrix.from(EquationMatrix m) : super.from(m);

  EquationMatrix.fromVectors(List<VectorModel> vectors, {bool vertical = false})
      : super.fromVectors(vectors, vertical: vertical);

  EquationMatrix.fromMatrix(MatrixModel m) : super.from(m);

  @override
  String toTeX({bool isDeterminant = false}) {
    StringBuffer buffer = StringBuffer();
    int rows = getRows();
    int cols = getColumns();

    buffer.write(r'\left( \begin{matrix} ');

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols - 1; c++) {
        buffer.write(this[r][c].reduce().toTeX());

        if (c != (cols - 1)) buffer.write(' & ');
      }
      if (r != (rows - 1)) buffer.write(r' \\ ');
    }

    buffer.write(r'\end{matrix} \middle\vert \, \begin{matrix} ');

    for (var r = 0; r < rows; r++) {
      buffer.write(this[r][cols - 1].reduce().toTeX());

      if (r != (rows - 1)) buffer.write(r' \\ ');
    }

    buffer.write(r'\end{matrix} \right)');

    return buffer.toString();
  }
}
