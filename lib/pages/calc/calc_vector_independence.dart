import 'package:dp_algebra/data/calc_data_controller.dart';
import 'package:dp_algebra/matrices/vector.dart';
import 'package:dp_algebra/widgets/vector_input.dart';
import 'package:flutter/material.dart';

class CalcVectorIndependence extends StatelessWidget {
  const CalcVectorIndependence({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Vector> vectors = CalcDataController.getVectors();
    return SingleChildScrollView(
      child: Column(
        children: [
          Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (var i = 0; i < vectors.length; i++)
                SizedBox(
                  width: 500,
                  child: VectorInput(
                    vector: vectors[i],
                    name: 'v$i',
                  ),
                ),
            ],
          ),
          const Divider(),
          const Text('Operace'),
          const OutlinedButton(
            onPressed: null,
            child: Text('Lineární nezávislost'),
          ),
          const Divider(),
          const Text('Výsledky:'),
        ],
      ),
    );
  }
}
