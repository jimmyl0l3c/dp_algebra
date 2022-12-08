import 'package:collection/collection.dart';
import 'package:dp_algebra/main.dart';
import 'package:dp_algebra/matrices/vector.dart';
import 'package:dp_algebra/matrices/vector_exceptions.dart';
import 'package:dp_algebra/matrices/vector_solution.dart';
import 'package:dp_algebra/models/calc_state/calc_vector_model.dart';
import 'package:dp_algebra/models/calc_state/calc_vector_solutions_model.dart';
import 'package:dp_algebra/pages/calc/utils.dart';
import 'package:dp_algebra/pages/exercise/utils.dart';
import 'package:dp_algebra/widgets/styled_dropdown.dart';
import 'package:dp_algebra/widgets/styled_popup.dart';
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
    Set<int> baseSelection =
        watchX((CalcVectorModel x) => x.vectorSelectionBase);
    Set<int> independenceSelection =
        watchX((CalcVectorModel x) => x.vectorSelectionIndependence);

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
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  const Text('Lineární nezávislost:'),
                  const SizedBox(width: 8.0),
                  StyledPopupButton<int>(
                    onSelected: (value) => getIt<CalcVectorModel>()
                        .checkVector(VectorSelectionType.independence, value),
                    itemBuilder: (context) => <PopupMenuItem<int>>[
                      for (var i = 0; i < vectors.length; i++)
                        CheckedPopupMenuItem<int>(
                          value: i,
                          checked: getIt<CalcVectorModel>()
                              .isChecked(VectorSelectionType.independence, i),
                          child: Text('v$i'),
                        ),
                    ],
                    child:
                        CalcUtils.vectorSelectionString(independenceSelection),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: independenceSelection.isEmpty
                        ? null
                        : () {
                            var selectedVectors = vectors
                                .whereIndexed(
                                    (i, v) => independenceSelection.contains(i))
                                .toList();
                            try {
                              getIt<CalcVectorSolutionsModel>().addSolution(
                                VectorSolution(
                                  vectors: selectedVectors,
                                  operation: VectorOperation.linearIndependence,
                                  solution: Vector.areLinearIndependent(
                                      selectedVectors),
                                ),
                              );
                            } on VectorException catch (e) {
                              ExerciseUtils.showError(context, e.errMessage());
                            }
                          },
                    child: const Text('Vypočítat'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  const Text('Nalezení báze:'),
                  const SizedBox(width: 8.0),
                  StyledPopupButton<int>(
                    onSelected: (value) => getIt<CalcVectorModel>()
                        .checkVector(VectorSelectionType.base, value),
                    itemBuilder: (context) => <PopupMenuItem<int>>[
                      for (var i = 0; i < vectors.length; i++)
                        CheckedPopupMenuItem<int>(
                          value: i,
                          checked: getIt<CalcVectorModel>()
                              .isChecked(VectorSelectionType.base, i),
                          child: Text('v$i'),
                        ),
                    ],
                    child: CalcUtils.vectorSelectionString(baseSelection),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      var selectedVectors = vectors
                          .whereIndexed((i, v) => baseSelection.contains(i))
                          .toList();
                      Vector.findBasis(selectedVectors);
                    },
                    child: const Text('Nalézt'),
                  ),
                ],
              ),
            ),
            VectorTransformMatrix(),
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

class VectorTransformMatrix extends StatefulWidget
    with GetItStatefulWidgetMixin {
  VectorTransformMatrix({Key? key}) : super(key: key);

  @override
  State<VectorTransformMatrix> createState() => _VectorTransformMatrixState();
}

class _VectorTransformMatrixState extends State<VectorTransformMatrix>
    with GetItStateMixin {
  int? selectedCoordinateVector;

  @override
  Widget build(BuildContext context) {
    List<Vector> vectors = watchX((CalcVectorModel x) => x.vectors);
    Set<int> transformA =
        watchX((CalcVectorModel x) => x.vectorSelectionTransformA);
    Set<int> transformB =
        watchX((CalcVectorModel x) => x.vectorSelectionTransformB);
    if (selectedCoordinateVector != null &&
        selectedCoordinateVector! >= vectors.length) {
      selectedCoordinateVector = null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          const Text('Transformace souřadnic:'),
          const SizedBox(width: 8.0),
          StyledPopupButton<int>(
            onSelected: (value) => getIt<CalcVectorModel>()
                .checkVector(VectorSelectionType.transformA, value),
            itemBuilder: (context) => <PopupMenuItem<int>>[
              for (var i = 0; i < vectors.length; i++)
                CheckedPopupMenuItem<int>(
                  value: i,
                  checked: getIt<CalcVectorModel>()
                      .isChecked(VectorSelectionType.transformA, i),
                  child: Text('v$i'),
                ),
            ],
            placeholder: 'Báze A',
            child: CalcUtils.vectorSelectionString(transformA),
          ),
          const SizedBox(width: 8.0),
          StyledPopupButton<int>(
            onSelected: (value) => getIt<CalcVectorModel>()
                .checkVector(VectorSelectionType.transformB, value),
            itemBuilder: (context) => <PopupMenuItem<int>>[
              for (var i = 0; i < vectors.length; i++)
                CheckedPopupMenuItem<int>(
                  value: i,
                  checked: getIt<CalcVectorModel>()
                      .isChecked(VectorSelectionType.transformB, i),
                  child: Text('v$i'),
                ),
            ],
            placeholder: 'Báze B',
            child: CalcUtils.vectorSelectionString(transformB),
          ),
          const SizedBox(width: 8.0),
          StyledDropdownButton<int>(
            value: selectedCoordinateVector,
            items: [
              for (var i = 0; i < vectors.length; i++)
                DropdownMenuItem<int>(
                  value: i,
                  child: Text('v$i'),
                ),
            ],
            onChanged: (i) {
              setState(() {
                selectedCoordinateVector = i;
              });
            },
            maxWidth: 60,
            isExpanded: true,
          ),
          const SizedBox(width: 8.0),
          const ElevatedButton(
            onPressed: null,
            child: Text('Vypočítat'),
          ),
        ],
      ),
    );
  }
}
