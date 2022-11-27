import 'package:dp_algebra/matrices/matrix.dart';
import 'package:dp_algebra/widgets/fraction_input.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class EquationInput extends StatefulWidget {
  final Matrix matrix;

  const EquationInput({
    Key? key,
    required this.matrix,
  }) : super(key: key);

  @override
  State<EquationInput> createState() => _EquationInputState();
}

class _EquationInputState extends State<EquationInput> {
  // TODO: add option to remove rows and columns
  @override
  Widget build(BuildContext context) {
    int extraCols = widget.matrix.getColumns() * 2 - 1;
    List<Widget> gridChildren = [];
    for (var i = 0; i < widget.matrix.getRows(); i++) {
      for (var j = 0; j < widget.matrix.getColumns(); j++) {
        gridChildren.add(FractionInput(
          onChanged: (Fraction? value) {
            if (value == null) return;
            widget.matrix.setValue(i, j, value);
          },
          value: widget.matrix[i][j].toDouble() != 0.0
              ? widget.matrix[i][j].toString()
              : null,
        ));
        if (j < widget.matrix.getColumns() - 1) {
          gridChildren.add(Center(child: Text('x$j')));
        }
        if (j < widget.matrix.getColumns() - 2) {
          gridChildren.add(const Center(child: Text('+')));
        }
        if (j == widget.matrix.getColumns() - 2) {
          gridChildren.add(const Center(child: Text('=')));
        }
      }
      gridChildren.add(Center(child: Text('y$i')));
    }

    return Card(
      child: Column(
        children: [
          SizedBox(
            width: 60 * (widget.matrix.getColumns().toDouble() + extraCols),
            child: GridView.count(
              crossAxisCount: widget.matrix.getColumns() + extraCols,
              shrinkWrap: true,
              mainAxisSpacing: 4.0,
              clipBehavior: Clip.antiAlias,
              crossAxisSpacing: 4.0,
              children: gridChildren,
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
                child: const Text('+ Rovnice'),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    widget.matrix.addColumn();
                  });
                },
                child: const Text('+ Neznámá'),
              )
            ],
          )
        ],
      ),
    );
  }
}
