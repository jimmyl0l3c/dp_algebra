import 'package:dp_algebra/logic/equation_matrix/equation_matrix.dart';
import 'package:dp_algebra/logic/general/tex_parsable.dart';
import 'package:dp_algebra/logic/vector/vector.dart';
import 'package:fraction/fraction.dart';

class EquationSolution implements TexParsable {
  final EquationMatrix equationMatrix;
  final Vector? solution;
  final GeneralSolution? generalSolution;
  final Object? stepByStep;

  EquationSolution({
    required this.equationMatrix,
    this.solution,
    this.generalSolution,
    this.stepByStep,
  });

  String toTeX() {
    StringBuffer buffer = StringBuffer();

    buffer.write(r'(A\vert y^T)=');
    buffer.write(equationMatrix.toTeX());
    buffer.write(', x=');
    if (solution != null) {
      buffer.write(solution?.toTeX());
    } else if (generalSolution != null) {
      buffer.write(generalSolution?.toTeX());
    } else {
      buffer.write('()');
    }

    return buffer.toString();
  }
}

class GeneralSolution {
  final Map<int, Map<int, Fraction>> _solution = {};
  final Map<int, Fraction> _numSolution = {};

  GeneralSolution(int variableCount) {
    for (var i = 0; i < variableCount; i++) {
      _solution[i] = {i: 1.toFraction()}; // all variables are free by default
      _numSolution[i] = 0.toFraction();
    }
  }

  void updateSolution(variableNum, key, value) {
    if (!_solution.containsKey(variableNum)) return;

    _solution[variableNum]![key] = value;
    _solution[variableNum]!.remove(variableNum); // remove, not a free variable
  }

  void updateNumSolution(variableNum, value) {
    if (!_numSolution.containsKey(variableNum)) return;

    _numSolution[variableNum] = value;
    _solution[variableNum]!.remove(variableNum); // remove, not a free variable
  }

  bool isZeroVector() {
    Fraction zero = 0.toFraction();
    for (var i = 0; i < _solution.length; i++) {
      if (_numSolution[i] != zero) return false;

      for (var key in _solution[i]!.keys) {
        if (_solution[i]![key] != zero) return false;
      }
    }
    return true;
  }

  bool isSingleSolution() {
    Fraction zero = 0.toFraction();
    for (var i in _solution.keys) {
      for (var j in _solution[i]!.keys) {
        if (_solution[i]![j] != zero) return false;
      }
    }
    return true;
  }

  List<Vector> toVectorList() {
    List<Vector> vectors = [_mapToVector(_numSolution)];

    if (!isSingleSolution()) {
      for (var i = 0; i < _numSolution.length; i++) {
        if (_solution.containsKey(i)) {
          vectors.add(_mapToVector(_solution[i]!));
        } else {
          vectors.add(Vector(length: _numSolution.length));
        }
      }
    }

    return vectors;
  }

  Vector _mapToVector(Map<int, Fraction> map) {
    List<Fraction> vectorValues = [];

    for (var i = 0; i < _numSolution.length; i++) {
      if (map.containsKey(i)) {
        vectorValues.add(map[i]!);
      } else {
        vectorValues.add(Fraction(0));
      }
    }

    return Vector.fromList(vectorValues);
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer('x = (');
    Fraction zero = Fraction(0);
    Fraction one = Fraction(1);
    Fraction minusOne = Fraction(-1);

    bool notZero = false;
    for (var i = 0; i < _solution.length; i++) {
      if (_numSolution[i] != zero) {
        buffer.write(_numSolution[i]);
      }

      _solution[i]?.forEach((key, value) {
        if (value > zero && _numSolution[i] != zero) {
          buffer.write('+');
        }
        if (value != zero) {
          if (value == minusOne) {
            buffer.write('-');
          } else if (value == one) {
            buffer.write('+');
          } else {
            buffer.write(value);
          }
          buffer.write('x$key');
          notZero = true;
        }
      });

      if (notZero == false) buffer.write('0');

      if (i != _solution.length - 1) {
        buffer.write('; ');
      }
      notZero = false;
    }

    buffer.write(')');
    return buffer.toString();
  }

  String toTeX() {
    Fraction zero = Fraction(0);
    Fraction one = Fraction(1);
    Fraction minusOne = Fraction(-1);

    StringBuffer buffer = StringBuffer(r'\begin{pmatrix} ');

    bool notZero = false;
    for (var i = 0; i < _solution.length; i++) {
      if (_numSolution[i] != zero) {
        buffer.write(_numSolution[i]);
        notZero = true;
      }

      _solution[i]?.forEach((key, value) {
        if (value > zero && _numSolution[i] != zero) {
          buffer.write('+');
        }
        if (value != zero) {
          if (value == minusOne) {
            buffer.write('-');
          } else if (value == one && notZero) {
            // buffer.write('+');
          } else if (value != one) {
            buffer.write(value);
          }
          buffer.write('x_{$key}');
          notZero = true;
        }
      });

      if (notZero == false) buffer.write('0');

      if (i != _solution.length - 1) {
        buffer.write(r' & ');
      }
      notZero = false;
    }

    buffer.write(r' \end{pmatrix}');
    return buffer.toString();
  }
}
