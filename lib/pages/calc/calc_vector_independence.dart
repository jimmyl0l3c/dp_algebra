import 'package:dp_algebra/data/calc_data_controller.dart';
import 'package:dp_algebra/matrices/equation_matrix.dart';
import 'package:dp_algebra/matrices/vector.dart';
import 'package:dp_algebra/matrices/vector_solution.dart';
import 'package:dp_algebra/widgets/vector_input.dart';
import 'package:flutter/material.dart';

class CalcVectorIndependence extends StatelessWidget {
  const CalcVectorIndependence({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Vector> vectors = CalcDataController.getVectors();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            Text(
              'Vektory',
              style: Theme.of(context).textTheme.headline4!,
            ),
            const SizedBox(height: 12),
            Column(
              // direction: Axis.vertical,
              // crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (var i = 0; i < vectors.length; i++)
                  VectorInput(
                    vector: vectors[i],
                    name: 'v$i',
                  ),
              ],
            ),
            const Divider(),
            Text(
              'Operace',
              style: Theme.of(context).textTheme.headline4!,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: ElevatedButton(
                onPressed: CalcDataController.getVectors().isEmpty
                    ? null
                    : () {
                        List<Vector> eqVectors = List<Vector>.from(vectors)
                          ..add(Vector(length: vectors.first.length()));
                        EquationMatrix m = EquationMatrix.fromVectors(
                          eqVectors,
                          vertical: true,
                        );
                        CalcDataController.addVectorSolution(VectorSolution(
                            vectors: vectors,
                            operation: VectorOperation.linearIndependence,
                            solution: m.solveByGauss().isZeroVector()));
                      },
                child: const Text('Lineární nezávislost'),
              ),
            ),
            const Divider(),
            Text(
              'Výsledky',
              style: Theme.of(context).textTheme.headline4!,
            ),
            const SizedBox(height: 12),
            StreamBuilder(
              stream: CalcDataController.vectorSolutionStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();

                List<Widget> solutions = [];
                for (var solution in snapshot.data!.reversed) {
                  if (solution.operation.solutionType == bool) {
                    solutions.add(Text(
                        '${solution.operation.description}: ${solution.solution ? 'Ano' : 'Ne'}'));
                  }
                }

                return Column(children: solutions);
              },
            ),
          ],
        ),
      ),
    );
  }
}
