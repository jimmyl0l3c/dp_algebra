import 'package:dp_algebra/logic/vector/vector.dart';
import 'package:flutter/widgets.dart';

enum VectorSelectionType { base, transformA, transformB, independence }

class CalcVectorModel extends ChangeNotifier {
  final vectors = ValueNotifier<List<Vector>>([Vector(length: 1)]);

  final vectorSelectionIndependence = ValueNotifier<Set<int>>({});
  final vectorSelectionBase = ValueNotifier<Set<int>>({});
  final vectorSelectionTransformA = ValueNotifier<Set<int>>({});
  final vectorSelectionTransformB = ValueNotifier<Set<int>>({});

  void addVector({Vector? vector}) {
    vectors.value.add(vector ?? Vector(length: 1));
    vectors.notifyListeners();
  }

  void removeVector(int index) {
    if (index < vectors.value.length) {
      vectors.value.removeAt(index);
      _removeVectorFromSelections(index);
      vectors.notifyListeners();
    }
  }

  void _removeVectorFromSelections(int index) {
    vectorSelectionIndependence.value.remove(index);
    vectorSelectionBase.value.remove(index);
    vectorSelectionTransformA.value.remove(index);
    vectorSelectionTransformB.value.remove(index);

    for (var i
        in vectorSelectionIndependence.value.where((j) => j > index).toList()) {
      vectorSelectionIndependence.value.remove(i);
      vectorSelectionIndependence.value.add(i - 1);
    }

    for (var i in vectorSelectionBase.value.where((j) => j > index).toList()) {
      vectorSelectionBase.value.remove(i);
      vectorSelectionBase.value.add(i - 1);
    }

    for (var i
        in vectorSelectionTransformA.value.where((j) => j > index).toList()) {
      vectorSelectionTransformA.value.remove(i);
      vectorSelectionTransformA.value.add(i - 1);
    }

    for (var i
        in vectorSelectionTransformB.value.where((j) => j > index).toList()) {
      vectorSelectionTransformB.value.remove(i);
      vectorSelectionTransformB.value.add(i - 1);
    }

    vectorSelectionIndependence.notifyListeners();
    vectorSelectionBase.notifyListeners();
    vectorSelectionTransformA.notifyListeners();
    vectorSelectionTransformB.notifyListeners();
  }

  void checkVector(VectorSelectionType type, int index) {
    if (index < vectors.value.length) {
      switch (type) {
        case VectorSelectionType.base:
          if (vectorSelectionBase.value.contains(index)) {
            vectorSelectionBase.value.remove(index);
          } else {
            vectorSelectionBase.value.add(index);
          }
          vectorSelectionBase.notifyListeners();
          break;
        case VectorSelectionType.transformA:
          if (vectorSelectionTransformA.value.contains(index)) {
            vectorSelectionTransformA.value.remove(index);
          } else {
            vectorSelectionTransformA.value.add(index);
          }
          vectorSelectionTransformA.notifyListeners();
          break;
        case VectorSelectionType.transformB:
          if (vectorSelectionTransformB.value.contains(index)) {
            vectorSelectionTransformB.value.remove(index);
          } else {
            vectorSelectionTransformB.value.add(index);
          }
          vectorSelectionTransformB.notifyListeners();
          break;
        case VectorSelectionType.independence:
          if (vectorSelectionIndependence.value.contains(index)) {
            vectorSelectionIndependence.value.remove(index);
          } else {
            vectorSelectionIndependence.value.add(index);
          }
          vectorSelectionIndependence.notifyListeners();
          break;
      }
    }
  }

  bool isChecked(VectorSelectionType type, int index) {
    switch (type) {
      case VectorSelectionType.base:
        return vectorSelectionBase.value.contains(index);
      case VectorSelectionType.transformA:
        return vectorSelectionTransformA.value.contains(index);
      case VectorSelectionType.transformB:
        return vectorSelectionTransformB.value.contains(index);
      case VectorSelectionType.independence:
        return vectorSelectionIndependence.value.contains(index);
    }
  }
}
