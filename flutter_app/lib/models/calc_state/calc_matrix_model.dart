import 'package:dp_algebra/logic/matrix/matrix.dart';
import 'package:flutter/widgets.dart';

class CalcMatrixModel extends ChangeNotifier {
  final matrices = ValueNotifier<Map<String, Matrix>>({'A': Matrix()});
  final canAddMatrix = ValueNotifier<bool>(true);

  final List<String> _availableNames = ['B', 'C', 'D', 'E', 'F', 'G'];

  String? addMatrix({Matrix? matrix}) {
    if (_availableNames.isEmpty) return null;

    String name = _availableNames.removeAt(0);

    matrices.value[name] = matrix ?? Matrix();
    matrices.notifyListeners();

    canAddMatrix.value = _availableNames.isNotEmpty;

    return name;
  }

  void removeMatrix(String name) {
    if (matrices.value.containsKey(name)) {
      matrices.value.remove(name);
      matrices.notifyListeners();
      _availableNames.insert(0, name);

      canAddMatrix.value = _availableNames.isNotEmpty;
    }
  }
}
