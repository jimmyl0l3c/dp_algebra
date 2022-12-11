import 'package:dp_algebra/logic/equation_matrix/equation_matrix.dart';
import 'package:flutter/widgets.dart';

class CalcEquationModel extends ChangeNotifier {
  final equationMatrix =
      ValueNotifier<EquationMatrix>(EquationMatrix(columns: 2));
}
