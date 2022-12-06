import 'package:dp_algebra/matrices/vector.dart';
import 'package:flutter/widgets.dart';

class CalcVectorModel extends ChangeNotifier {
  final vectors = ValueNotifier<List<Vector>>([Vector(length: 1)]);

  void addVector({Vector? vector}) {
    vectors.value.add(vector ?? Vector(length: 1));
    vectors.notifyListeners();
  }

  void removeVector(int index) {
    if (index < vectors.value.length) {
      vectors.value.removeAt(index);
      vectors.notifyListeners();
    }
  }
}
