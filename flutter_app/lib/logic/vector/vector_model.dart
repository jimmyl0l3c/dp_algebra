import 'package:dp_algebra/logic/general/extensions.dart';
import 'package:fraction/fraction.dart';

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

  VectorModel.from(VectorModel v) : _entries = List<Fraction>.from(v._entries);

  void addEntry({Fraction? f}) => _entries.add(f ?? 0.toFraction());

  Fraction removeEntry(int index) => _entries.removeAt(index);

  void setValue(int index, Fraction value) => _entries[index] = value;

  int length() => _entries.length;

  bool isSameSizeAs(VectorModel other) => length() == other.length();

  bool isZeroVector() => _entries.every((element) => element == Fraction(0));

  static bool areSameSize(List<VectorModel> vectors) {
    if (vectors.length < 2) return true;
    int length = vectors.first.length();

    for (var i = 1; i < vectors.length; i++) {
      if (length != vectors[i].length()) return false;
    }
    return true;
  }

  @override
  bool operator ==(Object other) {
    if (other is! VectorModel) return false;
    if (!isSameSizeAs(other)) return false;

    for (var i = 0; i < length(); i++) {
      if (_entries[i] != other[i]) return false;
    }
    return true;
  }

  Fraction operator [](int i) => _entries[i];

  void operator []=(int i, Fraction f) => _entries[i] = f;

  @override
  int get hashCode => _entries.hashCode;

  List<Fraction> asList() => _entries;

  @override
  String toString() {
    StringBuffer buffer = StringBuffer('(');

    for (var i = 0; i < length(); i++) {
      if (i == length() - 1) {
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

    for (var i = 0; i < length(); i++) {
      buffer.write(_entries[i].reduce().toTeX());

      if (i != (length() - 1)) buffer.write(' & ');
    }

    buffer.write(r' \end{pmatrix}');
    return buffer.toString();
  }
}
