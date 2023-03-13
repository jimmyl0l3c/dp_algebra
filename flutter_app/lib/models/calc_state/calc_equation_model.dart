import 'package:dp_algebra/models/input/matrix_model.dart';
import 'package:flutter/widgets.dart';

class CalcEquationModel extends ChangeNotifier {
  final equationMatrix = ValueNotifier<MatrixModel>(MatrixModel(columns: 2));
}
