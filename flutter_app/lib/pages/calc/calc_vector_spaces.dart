import 'package:algebra_lib/algebra_lib.dart';
import 'package:collection/collection.dart';
import 'package:dp_algebra/logic/vector/vector_model.dart';
import 'package:dp_algebra/main.dart';
import 'package:dp_algebra/models/calc_category.dart';
import 'package:dp_algebra/models/calc_expression_exception.dart';
import 'package:dp_algebra/models/calc_result.dart';
import 'package:dp_algebra/models/calc_state/calc_solutions_model.dart';
import 'package:dp_algebra/models/calc_state/calc_vector_model.dart';
import 'package:dp_algebra/utils/calc_utils.dart';
import 'package:dp_algebra/utils/utils.dart';
import 'package:dp_algebra/widgets/forms/styled_dropdown.dart';
import 'package:dp_algebra/widgets/forms/styled_popup.dart';
import 'package:dp_algebra/widgets/input/vector_input.dart';
import 'package:dp_algebra/widgets/layout/solution_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class CalcVectorSpaces extends StatelessWidget with GetItMixin {
  CalcVectorSpaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<VectorModel> vectors = watchX((CalcVectorModel x) => x.vectors);
    Set<int> baseSelection =
        watchX((CalcVectorModel x) => x.vectorSelectionBase);
    Set<int> independenceSelection =
        watchX((CalcVectorModel x) => x.vectorSelectionIndependence);

    List<CalcResult> solutions =
        watchX((CalcSolutionsModel x) => x.vectorSolutions);

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
                              getIt<CalcSolutionsModel>().addSolution(
                                CalcResult.calculate(
                                  AreVectorsLinearlyIndependent(
                                    vectors: selectedVectors
                                        .map((e) => e.toVector())
                                        .toList(),
                                  ),
                                ),
                                CalcCategory.vectorSpace,
                              );
                            } on CalcExpressionException catch (e) {
                              AlgebraUtils.showMessage(
                                context,
                                e.friendlyMessage,
                              );
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
                    onPressed: baseSelection.isEmpty
                        ? null
                        : () {
                            var selectedVectors = vectors
                                .whereIndexed(
                                    (i, v) => baseSelection.contains(i))
                                .toList();
                            try {
                              getIt<CalcSolutionsModel>().addSolution(
                                CalcResult.calculate(
                                  FindBasis(
                                    matrix: Matrix.fromVectors(
                                      selectedVectors
                                          .map((e) => e.toVector())
                                          .toList(),
                                    ),
                                  ),
                                ),
                                CalcCategory.vectorSpace,
                              );
                            } on CalcExpressionException catch (e) {
                              AlgebraUtils.showMessage(
                                context,
                                e.friendlyMessage,
                              );
                            }
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
              SolutionView(solution: solution),
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
    List<VectorModel> vectors = watchX((CalcVectorModel x) => x.vectors);
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Transformace souřadnic',
            style: Theme.of(context).textTheme.headline5!,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 4.0,
              children: [
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
                ElevatedButton(
                  onPressed: transformA.isEmpty || transformB.isEmpty
                      ? null
                      : () {
                          var solution = _getTransformMatrix(
                            context,
                            vectors,
                            transformA,
                            transformB,
                          );

                          if (solution != null) {
                            getIt<CalcSolutionsModel>().addSolution(
                              solution,
                              CalcCategory.vectorSpace,
                            );
                          }
                        },
                  child: const Text('Transformační Matice'),
                ),
              ],
            ),
          ),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            runSpacing: 4.0,
            children: [
              const Text('Souřadnice: '),
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
              ElevatedButton(
                onPressed: transformA.isEmpty ||
                        transformB.isEmpty ||
                        selectedCoordinateVector == null
                    ? null
                    : () {
                        var transformMatrix = _getTransformMatrix(
                          context,
                          vectors,
                          transformA,
                          transformB,
                        );

                        if (transformMatrix == null) return;

                        var selectedVector = vectors[selectedCoordinateVector!];
                        try {
                          getIt<CalcSolutionsModel>().addSolution(
                            CalcResult.calculate(
                              TransformCoords(
                                transformMatrix: transformMatrix.result,
                                coords: selectedVector.toVector(),
                              ),
                            ),
                            CalcCategory.vectorSpace,
                          );
                        } on CalcExpressionException catch (e) {
                          AlgebraUtils.showMessage(context, e.friendlyMessage);
                        }
                      },
                child: const Text('Transformovat'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  CalcResult? _getTransformMatrix(
    BuildContext context,
    List<VectorModel> vectors,
    Set<int> transformA,
    Set<int> transformB,
  ) {
    var basisA =
        vectors.whereIndexed((i, v) => transformA.contains(i)).toList();
    var basisB =
        vectors.whereIndexed((i, v) => transformB.contains(i)).toList();
    try {
      return CalcResult.calculate(TransformMatrix(
        basisA: Matrix.fromVectors(
          basisA.map((e) => e.toVector()).toList(),
        ),
        basisB: Matrix.fromVectors(
          basisB.map((e) => e.toVector()).toList(),
        ),
      ));
    } on CalcExpressionException catch (e) {
      AlgebraUtils.showMessage(context, e.friendlyMessage);
    }
    return null;
  }
}
