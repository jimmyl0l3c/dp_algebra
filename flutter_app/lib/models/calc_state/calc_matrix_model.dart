import 'package:dp_algebra/models/input/matrix_model.dart';
import 'package:flutter/widgets.dart';

class CalcMatrixModel extends ChangeNotifier {
  final matrices =
      ValueNotifier<Map<String, MatrixModel>>({'A': MatrixModel()});
  final canAddMatrix = ValueNotifier<bool>(true);

  final List<String> _availableNames = ['B', 'C', 'D', 'E', 'F', 'G'];

  String? addMatrix({MatrixModel? matrix}) {
    if (_availableNames.isEmpty) return null;

    String name = _availableNames.removeAt(0);

    matrices.value[name] = matrix ?? MatrixModel();
    matrices.notifyListeners();

    canAddMatrix.value = _availableNames.isNotEmpty;

    return name;
  }

  void removeMatrix(String name) {
    if (matrices.value.containsKey(name)) {
      matrices.value.remove(name);
      matrices.notifyListeners();
      _availableNames.add(name);
      _availableNames.sort();

      canAddMatrix.value = _availableNames.isNotEmpty;
    }
  }
}
