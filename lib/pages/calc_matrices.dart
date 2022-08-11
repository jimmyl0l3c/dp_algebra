import 'package:dp_algebra/matrices/matrix_operations.dart';
import 'package:dp_algebra/widgets/fraction_input.dart';
import 'package:dp_algebra/widgets/matrix_solution_view.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

import '../matrices/matrix.dart';
import '../matrices/matrix_exceptions.dart';
import '../matrices/solution.dart';
import '../widgets/matrix_input.dart';

class CalcMatrices extends StatefulWidget {
  const CalcMatrices({Key? key}) : super(key: key);

  @override
  State<CalcMatrices> createState() => _CalcMatricesState();
}

class _CalcMatricesState extends State<CalcMatrices> {
  late Map<String, Matrix> _matrices;
  final List<String> _namePool = ['B', 'C', 'D', 'E', 'F', 'G'];

  String? _binaryLeft = 'A';
  String? _binaryRight = 'A';
  String? _binaryOperation = '+';
  Fraction? _scalarC = Fraction(1);

  final List<Solution> _solutions = [];

  _CalcMatricesState() {
    _matrices = {'A': Matrix(columns: 2, rows: 2)};
  }

  @override
  Widget build(BuildContext context) {
    if (_matrices.isNotEmpty) {
      _binaryLeft ??= _matrices.keys.first;
      _binaryRight ??= _matrices.keys.first;
    }
    if (!_matrices.keys.contains(_binaryLeft)) {
      _binaryLeft = _matrices.isNotEmpty ? _matrices.keys.first : null;
    }
    if (!_matrices.keys.contains(_binaryRight)) {
      _binaryRight = _matrices.isNotEmpty ? _matrices.keys.first : null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulačka - Operace s maticemi'),
      ),
      body: Column(
        children: [
          Wrap(
            direction: Axis.horizontal,
            children: [
              for (var matrix in _matrices.entries)
                MatrixInput(
                  matrix: matrix.value,
                  name: matrix.key,
                  deleteMatrix: () {
                    setState(() {
                      _namePool.insert(0, matrix.key);
                      _matrices.remove(matrix.key);
                    });
                  },
                ),
              OutlinedButton(
                onPressed: _namePool.isNotEmpty
                    ? () {
                        if (_namePool.isEmpty) return;
                        setState(() {
                          _matrices[_namePool.removeAt(0)] =
                              Matrix(columns: 2, rows: 2);
                        });
                      }
                    : null,
                child: const Text('+'),
              ),
            ],
          ),
          const Divider(),
          const Text('Operace'),
          Row(
            children: [
              const Text('Binární operace'),
              DropdownButton<String>(
                value: _binaryLeft,
                items: [
                  for (var matrix in _matrices.entries)
                    DropdownMenuItem(
                      value: matrix.key,
                      child: Text(matrix.key),
                    ),
                ],
                onChanged: (String? val) {
                  setState(() {
                    _binaryLeft = val;
                  });
                },
              ),
              DropdownButton<String>(
                value: _binaryOperation,
                items: <String>['+', '-', '*']
                    .map<DropdownMenuItem<String>>((String operation) {
                  return DropdownMenuItem(
                    value: operation,
                    child: Text(operation),
                  );
                }).toList(),
                onChanged: (String? val) {
                  setState(() {
                    _binaryOperation = val;
                  });
                },
              ),
              DropdownButton<String>(
                value: _binaryRight,
                items: [
                  for (var matrix in _matrices.entries)
                    DropdownMenuItem(
                      value: matrix.key,
                      child: Text(matrix.key),
                    ),
                ],
                onChanged: (String? val) {
                  setState(() {
                    _binaryRight = val;
                  });
                },
              ),
              OutlinedButton(
                  onPressed: () {
                    if (_binaryLeft == null || _binaryRight == null) {
                      return; // TODO: show error
                    }
                    Matrix? a = _matrices[_binaryLeft];
                    Matrix? b = _matrices[_binaryRight];
                    if (a == null || b == null) return; // TODO: show error
                    Matrix? solution;
                    MatrixOperation? operation;
                    try {
                      switch (_binaryOperation) {
                        case '+':
                          operation = MatrixOperation.add;
                          solution = a + b;
                          break;
                        case '-':
                          operation = MatrixOperation.diff;
                          solution = a - b;
                          break;
                        case '*':
                          operation = MatrixOperation.multiply;
                          solution = a * b;
                          break;
                        default:
                          return;
                      }
                    } on MatrixSizeMismatchException {
                      // TODO: show error
                      return;
                    } on MatrixMultiplySizeException {
                      // TODO: show error
                      return;
                    }
                    Matrix leftOp = Matrix.from(a);
                    setState(() {
                      _solutions.add(Solution(
                        leftOp: leftOp,
                        rightOp: a == b ? leftOp : Matrix.from(b),
                        operation: operation!,
                        solution: solution,
                      ));
                    });
                  },
                  child: const Text('=')),
              IconButton(
                onPressed: () {
                  if (_binaryLeft == _binaryRight) return;
                  setState(() {
                    String? tmp = _binaryLeft;
                    _binaryLeft = _binaryRight;
                    _binaryRight = tmp;
                  });
                },
                icon: const Icon(Icons.change_circle),
                iconSize: 20.0,
                splashRadius: 21.0,
              )
            ],
          ),
          Row(
            children: [
              const Text('Násobení matice skalárem:'),
              SizedBox(
                width: 80,
                child: FractionInput(
                  onChanged: (String value) {
                    if (value.isEmpty) {
                      _scalarC = Fraction(0);
                    } else if (value.contains('.')) {
                      double? dValue = double.tryParse(value);
                      if (dValue == null) return;
                      _scalarC = dValue.toFraction();
                    } else {
                      if (value.startsWith('/')) value = '0$value';
                      if (!value.isFraction) return;
                      _scalarC = value.toFraction();
                    }
                  },
                  initialValue: _scalarC.toString(),
                ),
              ),
              const Icon(Icons.close),
              ToggleButtons(
                isSelected: [
                  for (var i = 0; i < _matrices.length; i++) false,
                ],
                children: [
                  for (var matrix in _matrices.entries) Text(matrix.key),
                ],
                onPressed: (int index) {
                  Matrix? m = _matrices[_matrices.keys.elementAt(index)];
                  if (m == null) return;
                  Matrix? solution = m * _scalarC;
                  setState(() {
                    _solutions.add(Solution(
                      leftOp: _scalarC,
                      rightOp: Matrix.from(m),
                      operation: MatrixOperation.multiply,
                      solution: solution,
                    ));
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text('Determinant'),
              ToggleButtons(
                isSelected: [
                  for (var i = 0; i < _matrices.length; i++) false,
                ],
                children: [
                  for (var matrix in _matrices.entries) Text(matrix.key),
                ],
                onPressed: (int index) {
                  Matrix? m = _matrices[_matrices.keys.elementAt(index)];
                  if (m == null) return;
                  Fraction? solution;
                  try {
                    solution = m.getDeterminant();
                  } on MatrixIsNotSquareException {
                    // TODO: show error
                    return;
                  }
                  setState(() {
                    _solutions.add(Solution(
                      leftOp: Matrix.from(m),
                      operation: MatrixOperation.det,
                      solution: solution,
                    ));
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text('Transponovaná matice'),
              ToggleButtons(
                isSelected: [
                  for (var i = 0; i < _matrices.length; i++) false,
                ],
                children: [
                  for (var matrix in _matrices.entries) Text(matrix.key),
                ],
                onPressed: (int index) {
                  Matrix? m = _matrices[_matrices.keys.elementAt(index)];
                  if (m == null) return;
                  Matrix? solution = m.getTransposed();
                  setState(() {
                    _solutions.add(Solution(
                      leftOp: Matrix.from(m),
                      operation: MatrixOperation.transpose,
                      solution: solution,
                    ));
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text('Inverzní matice'),
              ToggleButtons(
                isSelected: [
                  for (var i = 0; i < _matrices.length; i++) false,
                ],
                children: [
                  for (var matrix in _matrices.entries) Text(matrix.key),
                ],
                onPressed: (int index) {
                  Matrix? m = _matrices[_matrices.keys.elementAt(index)];
                  if (m == null) return;
                  Matrix? solution;
                  try {
                    solution = m.getInverse();
                  } on MatrixInverseImpossibleException {
                    // TODO: show error
                    return;
                  }
                  setState(() {
                    _solutions.add(Solution(
                      leftOp: Matrix.from(m),
                      operation: MatrixOperation.inverse,
                      solution: solution,
                    ));
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              OutlinedButton(
                  onPressed: () {
                    Matrix a = _matrices.values.first;
                    print(a);
                    a.addRowToRowNTimes(0, 1, Fraction(-3, 2));
                    print(a);
                  },
                  child: const Text('Debug: 1.row + (-3/2) * 0.row')),
              OutlinedButton(
                  onPressed: () {
                    Matrix a = _matrices.values.first;
                    print(a);
                    a.multiplyRowByN(1, Fraction(-2));
                    print(a);
                  },
                  child: const Text('Debug: 1.row * (-2)')),
              OutlinedButton(
                  onPressed: () {
                    Matrix a = _matrices.values.first;
                    print(a);
                    a.exchangeRows(0, 1);
                    print(a);
                  },
                  child: const Text('Debug: Exchange rows 0. and 1.')),
            ],
          ),
          const Divider(),
          const Text('Výsledky:'),
          for (var solution in _solutions.reversed)
            SolutionView(solution: solution, matrices: _matrices),
        ],
      ),
    );
  }
}
