import 'package:dp_algebra/widgets/matrix_input.dart';
import 'package:flutter/material.dart';

import '../matrices/matrix.dart';

class CalcMatrices extends StatefulWidget {
  const CalcMatrices({Key? key}) : super(key: key);

  @override
  State<CalcMatrices> createState() => _CalcMatricesState();
}

class _CalcMatricesState extends State<CalcMatrices> {
  late Map<String, Matrix> _matrices;

  _CalcMatricesState() {
    _matrices = {'A': Matrix(columns: 2, rows: 2)};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulačka - Operace s maticemi'),
      ),
      body: Wrap(
        direction: Axis.horizontal,
        children: [
          MatrixInput(matrix: _matrices['A']!),
        ],
      ),
    );
  }
}
