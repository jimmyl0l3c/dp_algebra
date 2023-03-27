import 'package:big_fraction/big_fraction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../models/input/matrix_model.dart';
import '../forms/button_row.dart';
import 'fraction_input.dart';

class EquationInput extends StatefulWidget {
  final MatrixModel matrix;

  const EquationInput({
    Key? key,
    required this.matrix,
  }) : super(key: key);

  @override
  State<EquationInput> createState() => _EquationInputState();
}

class _EquationInputState extends State<EquationInput> {
  @override
  Widget build(BuildContext context) {
    List<List<Widget>> eqWidgets = [];
    for (var i = 0; i < widget.matrix.rows; i++) {
      eqWidgets.add([]);
      for (var j = 0; j < widget.matrix.columns; j++) {
        List<Widget> valueRow = [];
        valueRow.add(FractionInput(
          maxWidth: 60,
          onChanged: (BigFraction? value) {
            if (value == null) return;
            widget.matrix.setValue(i, j, value);
          },
          value: widget.matrix[i][j].toDouble() != 0.0
              ? widget.matrix[i][j].toString()
              : null,
        ));
        if (j < widget.matrix.columns - 1) {
          valueRow.add(Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: PopupMenuButton<String>(
              tooltip: widget.matrix.columns > 2 ? 'Upravit neznámou' : '',
              enabled: widget.matrix.columns > 2,
              onSelected: (value) {
                if (value == 'delete' && widget.matrix.columns > 2) {
                  setState(() {
                    widget.matrix.removeColumn(j);
                  });
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'none', child: Text('Zavřít')),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    'Odebrat',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
              child: Math.tex(
                'x_{$j}',
                textScaleFactor: 1.4,
                mathStyle: MathStyle.text,
              ),
            ),
          ));
        } else if (j == widget.matrix.columns - 1) {
          valueRow.add(Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: PopupMenuButton<String>(
              tooltip: widget.matrix.rows > 1 ? 'Upravit rovnici' : '',
              enabled: widget.matrix.rows > 1,
              onSelected: (value) {
                if (value == 'delete' && widget.matrix.rows > 1) {
                  setState(() {
                    widget.matrix.removeRow(i);
                  });
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'none', child: Text('Zavřít')),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    'Odebrat',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
              child: Math.tex(
                'y_{$i}',
                textScaleFactor: 1.4,
                mathStyle: MathStyle.text,
              ),
            ),
          ));
        }
        eqWidgets[i].add(Row(
          mainAxisSize: MainAxisSize.min,
          children: valueRow,
        ));
        if (j < widget.matrix.columns - 2) {
          eqWidgets[i].add(const Text('+'));
        }
        if (j == widget.matrix.columns - 2) {
          eqWidgets[i].add(const Text('='));
        }
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          children: [
            for (var r = 0; r < widget.matrix.rows; r++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Wrap(
                  runSpacing: 4,
                  spacing: 8,
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: eqWidgets[r],
                ),
              ),
            ButtonRow(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              children: [
                ButtonRowItem(
                    child: const Text('+ Rovnice'),
                    onPressed: () {
                      setState(() {
                        widget.matrix.addRow();
                      });
                    }),
                ButtonRowItem(
                    child: const Text('+ Neznámá'),
                    onPressed: () {
                      setState(() {
                        widget.matrix.addColumn();
                      });
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
