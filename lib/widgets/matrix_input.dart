import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fraction/fraction.dart';

import '../matrices/matrix.dart';

class MatrixInput extends StatefulWidget {
  final Matrix matrix;
  final String name;

  const MatrixInput({
    Key? key,
    required this.matrix,
    required this.name,
  }) : super(key: key);

  @override
  State<MatrixInput> createState() => _MatrixInputState();
}

class _MatrixInputState extends State<MatrixInput> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(widget.name),
          Container(
            width: 60 * widget.matrix.getColumns().toDouble(),
            child: GridView.count(
              crossAxisCount: widget.matrix.getColumns(),
              shrinkWrap: true,
              mainAxisSpacing: 4.0,
              clipBehavior: Clip.antiAlias,
              crossAxisSpacing: 4.0,
              children: [
                for (var i = 0; i < widget.matrix.getRows(); i++)
                  for (var j = 0; j < widget.matrix.getColumns(); j++)
                    Container(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: '0',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            widget.matrix.setValue(i, j, 0.toFraction());
                          } else if (value.contains('.')) {
                            double? dValue = double.tryParse(value);
                            if (dValue == null) return;
                            widget.matrix.setValue(i, j, dValue.toFraction());
                          } else {
                            if (!value.isFraction) return;
                            widget.matrix.setValue(i, j, value.toFraction());
                          }
                        },
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
                            if (index == value.length - 1)
                              return 'Nelze dělit nulou';
                            int? parsed =
                                int.tryParse(value.substring(index + 1));
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
                    ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    widget.matrix.addRow();
                  });
                },
                child: const Text('+ Řádek'),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    widget.matrix.addColumn();
                  });
                },
                child: const Text('+ Sloupec'),
              )
            ],
          )
        ],
      ),
    );
  }
}
