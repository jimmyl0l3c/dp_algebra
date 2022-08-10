import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fraction/fraction.dart';

import '../matrices/matrix.dart';

class MatrixInput extends StatefulWidget {
  final Matrix matrix;

  const MatrixInput({
    Key? key,
    required this.matrix,
  }) : super(key: key);

  @override
  State<MatrixInput> createState() => _MatrixInputState();
}

class _MatrixInputState extends State<MatrixInput> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 250,
        height: 250,
        child: GridView.count(
          crossAxisCount: widget.matrix.getColumns(),
          children: [
            for (var i = 0; i < widget.matrix.getRows(); i++)
              for (var j = 0; j < widget.matrix.getColumns(); j++)
                TextFormField(
                  decoration: const InputDecoration(hintText: '0'),
                  onChanged: (value) {},
                  inputFormatters: [
                    FilteringTextInputFormatter(
                      RegExp(r'^[+-]?[0-9]*[./]?[0-9]*'),
                      allow: true,
                    )
                  ],
                  initialValue: widget.matrix[i][j].toDouble() != 0.0
                      ? widget.matrix[i][j].toString()
                      : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) return null;
                    if (value.contains('/')) {
                      int index = value.indexOf('/');
                      if (index == value.length - 1) return 'Nelze dělit nulou';
                      int? parsed = int.tryParse(value.substring(index + 1));
                      if (parsed == null || parsed == 0) {
                        return 'Nelze dělit nulou';
                      }
                    }
                    if (value.contains('.')) {
                      return double.tryParse(value) == null
                          ? 'Neplatná hodnota'
                          : null;
                    }
                    if (!value.isFraction) return 'Neplatná hodnota';
                    return null;
                  },
                ),
          ],
        ),
      ),
    );
  }
}
