import 'package:algebra_lib/algebra_lib.dart';
import 'package:fraction/fraction.dart';
import 'package:precise_fractions/precise_fractions.dart';

import '../../utils/extensions.dart';

class VectorModel {
  List<Fraction> _entries = List<Fraction>.empty(growable: true);

  VectorModel({int length = 1}) {
    _entries = [];
    for (var i = 0; i < length; i++) {
      _entries.add(0.toFraction());
    }
  }

  VectorModel.fromList(List<Fraction> entries)
      : _entries = List<Fraction>.from(entries);

  VectorModel.fromVector(Vector vector)
      : _entries =
            vector.items.map((e) => (e as Scalar).value.toFraction()).toList();

  VectorModel.from(VectorModel v) : _entries = List<Fraction>.from(v._entries);

  int get length => _entries.length;

  bool get isZeroVector => _entries.every((element) => element == Fraction(0));

  bool isSameSizeAs(VectorModel other) => length == other.length;

  static bool areSameSize(List<VectorModel> vectors) {
    if (vectors.length < 2) return true;
    int length = vectors.first.length;

    for (var i = 1; i < vectors.length; i++) {
      if (length != vectors[i].length) return false;
    }
    return true;
  }

  void add({Fraction? f}) => _entries.add(f ?? 0.toFraction());

  Fraction removeAt(int index) => _entries.removeAt(index);

  void set(int index, Fraction value) => _entries[index] = value;

  @override
  bool operator ==(Object other) {
    if (other is! VectorModel) return false;
    if (!isSameSizeAs(other)) return false;

    for (var i = 0; i < length; i++) {
      if (_entries[i] != other[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_entries);

  Fraction operator [](int i) => _entries[i];

  void operator []=(int i, Fraction f) => _entries[i] = f;

  List<Fraction> asList() => _entries;

  @override
  String toString() {
    StringBuffer buffer = StringBuffer('(');

    for (var i = 0; i < length; i++) {
      if (i == length - 1) {
        buffer.write(_entries[i].reduce().toString());
      } else {
        buffer.write('${_entries[i].reduce().toString()}; ');
      }
    }
    buffer.write(')');
    return buffer.toString();
  }

  String toTeX() {
    StringBuffer buffer = StringBuffer(r'\begin{pmatrix} ');

    for (var i = 0; i < length; i++) {
      buffer.write(_entries[i].reduce().toTeX());

      if (i != (length - 1)) buffer.write(' & ');
    }

    buffer.write(r' \end{pmatrix}');
    return buffer.toString();
  }

  Vector toVector() => Vector(
      items: _entries.map((e) => Scalar(value: e.toPreciseFrac())).toList());
}
