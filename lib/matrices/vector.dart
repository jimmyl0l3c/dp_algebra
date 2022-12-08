import 'package:dp_algebra/matrices/equation_matrix.dart';
import 'package:dp_algebra/matrices/extensions.dart';
import 'package:dp_algebra/matrices/matrix_exceptions.dart';
import 'package:dp_algebra/matrices/vector_exceptions.dart';
import 'package:fraction/fraction.dart';

class Vector {
  List<Fraction> _entries = List<Fraction>.empty(growable: true);

  Vector({int length = 1}) {
    _entries = [];
    for (var i = 0; i < length; i++) {
      _entries.add(0.toFraction());
    }
  }

  Vector.fromList(List<Fraction> entries)
      : _entries = List<Fraction>.from(entries);

  Vector.from(Vector v) : _entries = List<Fraction>.from(v._entries);

  void addEntry({Fraction? f}) => _entries.add(f ?? 0.toFraction());

  Fraction removeEntry(int index) => _entries.removeAt(index);

  void setValue(int index, Fraction value) => _entries[index] = value;

  int length() => _entries.length;

  bool isSameSizeAs(Vector other) => length() == other.length();

  bool isLinearIndependent(Vector other) => areLinearIndependent([this, other]);

  static bool areLinearIndependent(List<Vector> vectors) {
    EquationMatrix m = EquationMatrix.fromVectors(
      vectors..add(Vector(length: vectors.first.length())),
      vertical: true,
    );
    return m.solveByGauss().isZeroVector();
  }

  Vector doEntryWiseOperation(
    Vector other,
    Fraction Function(Fraction, Fraction) operation,
    String operationSymbol,
  ) {
    if (!isSameSizeAs(other)) throw VectorSizeMismatchException();

    Vector output = Vector(length: length());
    for (var i = 0; i < length(); i++) {
      output[i] = operation(_entries[i], other[i]);
    }

    return output;
  }

  Vector operator +(Object other) {
    if (other is Vector) {
      return doEntryWiseOperation(other, (vi, ui) => vi + ui, '+');
    } else if (other is Fraction) {
      Vector output = Vector.from(this);
      for (var i = 0; i < length(); i++) {
        output[i] += other;
      }

      return output;
    }
    throw InvalidTypeException();
  }

  Vector operator -(Object other) {
    if (other is Vector) {
      return doEntryWiseOperation(other, (vi, ui) => vi - ui, '-');
    } else if (other is Fraction) {
      Vector output = Vector.from(this);
      for (var i = 0; i < length(); i++) {
        output[i] -= other;
      }

      return output;
    }
    throw InvalidTypeException();
  }

  Vector operator *(Object other) {
    if (other is Vector) {
      return doEntryWiseOperation(other, (vi, ui) => vi * ui, '*');
    } else if (other is Fraction) {
      Vector output = Vector.from(this);
      for (var i = 0; i < length(); i++) {
        output[i] *= other;
      }

      return output;
    }
    throw InvalidTypeException();
  }

  @override
  bool operator ==(Object other) {
    if (other is! Vector) return false;
    if (!isSameSizeAs(other)) return false;

    for (var i = 0; i < length(); i++) {
      if (_entries[i] != other[i]) return false;
    }
    return true;
  }

  Fraction operator [](int i) => _entries[i];

  void operator []=(int i, Fraction f) => _entries[i] = f;

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

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
