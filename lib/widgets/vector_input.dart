import 'package:dp_algebra/matrices/vector.dart';
import 'package:dp_algebra/widgets/fraction_input.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class VectorInput extends StatefulWidget {
  final Vector vector;
  final String? name;
  final VoidCallback? deleteMatrix;

  const VectorInput({
    Key? key,
    required this.vector,
    this.name,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          children: [
            if (widget.name != null || widget.deleteMatrix != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.name != null) Text(widget.name!),
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
              ),
            Wrap(
              direction: Axis.horizontal,
              children: [
                for (var i = 0; i < widget.vector.length(); i++)
                  FractionInput(
                      maxWidth: 60,
                      onChanged: (Fraction? value) {
                        if (value == null) return;
                        widget.vector.setValue(i, value);
                      },
                      value: widget.vector[i].toDouble() != 0.0
                          ? widget.vector[i].toString()
                          : null),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.vector.addEntry();
                  });
                },
                child: const Text('+ Prvek'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
