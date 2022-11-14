import 'dart:math';

import 'package:dp_algebra/matrices/matrix.dart';
import 'package:dp_algebra/widgets/matrix_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:fraction/fraction.dart';

class BinaryMatrixExc extends StatefulWidget {
  const BinaryMatrixExc({Key? key}) : super(key: key);

  @override
  State<BinaryMatrixExc> createState() => _BinaryMatrixExcState();
}

class _BinaryMatrixExcState extends State<BinaryMatrixExc> {
  Random random = Random();

  Matrix matrixA = Matrix(columns: 1, rows: 1);
  Matrix matrixB = Matrix(columns: 1, rows: 1);
  Matrix solution = Matrix(columns: 1, rows: 1);
  String operationSymbol = '+';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
        vertical: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.horizontal,
            children: [
              const Text('Vygenerovat: '),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    operationSymbol = '+';
                    int rows = generateSize();
                    int cols = generateSize();
                    matrixA = generateMatrix(rows: rows, columns: cols);
                    matrixB = generateMatrix(rows: rows, columns: cols);
                  });
                },
                child: const Text('Sčítání'),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    operationSymbol = '-';
                    int rows = generateSize();
                    int cols = generateSize();
                    matrixA = generateMatrix(rows: rows, columns: cols);
                    matrixB = generateMatrix(rows: rows, columns: cols);
                  });
                },
                child: const Text('Odčítání'),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    operationSymbol = r'\cdot';
                    int rows = generateSize();
                    int cols = generateSize();
                    int cols2 = generateSize();
                    matrixA = generateMatrix(rows: rows, columns: cols);
                    matrixB = generateMatrix(rows: cols, columns: cols2);
                  });
                },
                child: const Text('Násobení'),
              ),
              const OutlinedButton(
                onPressed: null,
                child: Text('Náhodně'),
              ),
              const VerticalDivider(),
              OutlinedButton(
                onPressed: null,
                child: const Text('Zkontrolovat'),
              ),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.horizontal,
            children: [
              Math.tex(
                '${matrixA.toTeX()} $operationSymbol ${matrixB.toTeX()} =',
                textScaleFactor: 1.4,
              ),
              MatrixInput(matrix: solution, name: 'C', deleteMatrix: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Matrix generateMatrix({int? rows, int? columns}) {
    rows ??= generateSize();
    columns ??= generateSize();

    Matrix m = Matrix(rows: rows, columns: columns);

    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < columns; j++) {
        m[i][j] = generateFraction();
      }
    }

    return m;
  }

  Fraction generateFraction() {
    int num = random.nextInt(100) - 50;
    return num.toFraction();
  }

  int generateSize() => random.nextInt(4) + 1;
}
