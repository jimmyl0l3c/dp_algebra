import 'dart:math';

import 'package:algebra_lib/algebra_lib.dart';
import 'package:big_fraction/big_fraction.dart';

import '../../utils/extensions.dart';

class VectorModel {
  List<BigFraction> _entries = List<BigFraction>.empty(growable: true);

  VectorModel({int length = 1}) {
    _entries = [];
    for (var i = 0; i < length; i++) {
      _entries.add(0.toBigFraction());
    }
  }

  void regenerateValues() {
    Random r = Random();

    for (var i = 0; i < length; i++) {
      _entries[i] = BigFraction.from(r.nextInt(21) - 10);
    }
  }

  VectorModel.fromList(List<BigFraction> entries)
      : _entries = List<BigFraction>.from(entries);

  VectorModel.fromVector(Vector vector)
      : _entries = vector.items.map((e) => (e as Scalar).value).toList();

  VectorModel.from(VectorModel v)
      : _entries = List<BigFraction>.from(v._entries);

  int get length => _entries.length;

  bool get isZeroVector =>
      _entries.every((element) => element == BigFraction.zero());

  bool isSameSizeAs(VectorModel other) => length == other.length;

  static bool areSameSize(List<VectorModel> vectors) {
    if (vectors.length < 2) return true;
    int length = vectors.first.length;

    for (var i = 1; i < vectors.length; i++) {
      if (length != vectors[i].length) return false;
    }
    return true;
  }

  void add({BigFraction? f}) => _entries.add(f ?? 0.toBigFraction());

  BigFraction removeAt(int index) => _entries.removeAt(index);

  void set(int index, BigFraction value) => _entries[index] = value;

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

  BigFraction operator [](int i) => _entries[i];

  void operator []=(int i, BigFraction f) => _entries[i] = f;

  List<BigFraction> asList() => _entries;

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

  Vector toVector() => Vector(items: _entries.map((e) => Scalar(e)).toList());
}
