import 'package:flutter/widgets.dart';

import '../input/matrix_model.dart';

/// Singleton, used to store current Calc state (Equation section)
class CalcEquationModel extends ChangeNotifier {
  final equationMatrix = ValueNotifier<MatrixModel>(MatrixModel(columns: 2));
}
