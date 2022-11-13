import 'package:dp_algebra/matrices/vector.dart';
import 'package:dp_algebra/widgets/fraction_input.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class VectorInput extends StatefulWidget {
  final Vector vector;
  final String name;
  final VoidCallback? deleteMatrix;

  const VectorInput({
    Key? key,
    required this.vector,
    required this.name,
    this.deleteMatrix,
  }) : super(key: key);

  @override
  State<VectorInput> createState() => _VectorInputState();
}

class _VectorInputState extends State<VectorInput> {
  // TODO: add option to remove entries
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.name),
              if (widget.deleteMatrix != null)
                IconButton(
                  onPressed: widget.deleteMatrix,
                  icon: const Icon(Icons.close),
                  iconSize: 12.0,
                  splashRadius: 15.0,
                  color: Colors.redAccent,
                ),
            ],
          ),
          Wrap(
            direction: Axis.horizontal,
            children: [
              for (var i = 0; i < widget.vector.length(); i++)
                SizedBox(
                  width: 60,
                  child: FractionInput(
                      onChanged: (String value) {
                        if (value.isEmpty) {
                          widget.vector.setValue(i, 0.toFraction());
                        } else if (value.contains('.')) {
                          double? dValue = double.tryParse(value);
                          if (dValue == null) return;
                          widget.vector.setValue(i, dValue.toFraction());
                        } else {
                          if (value.startsWith('/')) value = '0$value';
                          if (!value.isFraction) return;
                          widget.vector.setValue(i, value.toFraction());
                        }
                      },
                      value: widget.vector[i].toDouble() != 0.0
                          ? widget.vector[i].toString()
                          : null),
                ),
            ],
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                widget.vector.addEntry();
              });
            },
            child: const Text('+ Prvek'),
          ),
        ],
      ),
    );
  }
}
