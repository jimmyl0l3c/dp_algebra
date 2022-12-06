import 'package:dp_algebra/matrices/equation_matrix.dart';
import 'package:flutter/widgets.dart';

class CalcEquationModel extends ChangeNotifier {
  final equationMatrix =
      ValueNotifier<EquationMatrix>(EquationMatrix(columns: 2));
}
