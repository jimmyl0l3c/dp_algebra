import 'package:dp_algebra/main.dart';
import 'package:dp_algebra/matrices/equation_matrix.dart';
import 'package:dp_algebra/matrices/vector.dart';
import 'package:dp_algebra/matrices/vector_exceptions.dart';
import 'package:dp_algebra/matrices/vector_solution.dart';
import 'package:dp_algebra/models/calc_state/calc_vector_model.dart';
import 'package:dp_algebra/models/calc_state/calc_vector_solutions_model.dart';
import 'package:dp_algebra/pages/exercise/utils.dart';
import 'package:dp_algebra/widgets/vector_input.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class CalcVectorSpaces extends StatelessWidget with GetItMixin {
  CalcVectorSpaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Vector> vectors = watchX((CalcVectorModel x) => x.vectors);
    List<VectorSolution> solutions =
        watchX((CalcVectorSolutionsModel x) => x.solutions);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Vektory',
                  style: Theme.of(context).textTheme.headline4!,
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: getIt<CalcVectorModel>().addVector,
                  child: const Text('+'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < vectors.length; i++)
              VectorInput(
                vector: vectors[i],
                name: 'v$i',
                deleteVector: () => getIt<CalcVectorModel>().removeVector(i),
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
                onPressed: vectors.isEmpty
                    ? null
                    : () {
                        List<Vector> eqVectors = List<Vector>.from(vectors)
                          ..add(Vector(length: vectors.first.length()));
                        try {
                          EquationMatrix m = EquationMatrix.fromVectors(
                            eqVectors,
                            vertical: true,
                          );
                          getIt<CalcVectorSolutionsModel>().addSolution(
                            VectorSolution(
                                vectors: vectors,
                                operation: VectorOperation.linearIndependence,
                                solution: m.solveByGauss().isZeroVector()),
                          );
                        } on VectorException catch (e) {
                          ExerciseUtils.showError(context, e.errMessage());
                        }
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
            for (var solution in solutions.reversed)
              Text(
                  '${solution.operation.description}: ${solution.solution ? 'Ano' : 'Ne'}')
          ],
        ),
      ),
    );
  }
}
