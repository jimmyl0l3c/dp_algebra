import 'package:algebra_lib/algebra_lib.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../../data/predefined_refs.dart';
import '../../main.dart';
import '../../models/calc/calc_category.dart';
import '../../models/calc/calc_expression_exception.dart';
import '../../models/calc/calc_result.dart';
import '../../models/calc_state/calc_solutions_model.dart';
import '../../models/calc_state/calc_vector_model.dart';
import '../../models/input/vector_model.dart';
import '../../utils/calc_utils.dart';
import '../../utils/utils.dart';
import '../../widgets/forms/styled_dropdown.dart';
import '../../widgets/forms/styled_popup.dart';
import '../../widgets/hint.dart';
import '../../widgets/info_button.dart';
import '../../widgets/input/vector_input.dart';
import '../../widgets/layout/solution_view.dart';
import '../../widgets/learn/block_ref_button.dart';

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

    const String linIndependence = "Lineární nezávislost:";
    const String findBasis = "Nalezení báze:";

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
                  style: Theme.of(context).textTheme.headlineMedium!,
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
              style: Theme.of(context).textTheme.headlineMedium!,
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
                  BlockRefButton(
                    refName: PredefinedRef.vectorLinIndependence.refName,
                    placeholder: linIndependence,
                    text: linIndependence,
                  ),
                  const SizedBox(width: 8.0),
                  StyledPopupButton<int>(
                    onSelected: (value) => getIt<CalcVectorModel>()
                        .selectVector(VectorSelectionType.independence, value),
                    itemBuilder: (context) => <PopupMenuItem<int>>[
                      for (var i = 0; i < vectors.length; i++)
                        CheckedPopupMenuItem<int>(
                          value: i,
                          checked: getIt<CalcVectorModel>()
                              .isChecked(VectorSelectionType.independence, i),
                          child: Text('v$i'),
                        ),
                    ],
                    child: vectorSelectionString(independenceSelection),
                    tooltip: "Zvolte vektory",
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
                              showSnackBarMessage(
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
                  BlockRefButton(
                    refName: PredefinedRef.basis.refName,
                    placeholder: findBasis,
                    text: findBasis,
                  ),
                  const SizedBox(width: 8.0),
                  StyledPopupButton<int>(
                    onSelected: (value) => getIt<CalcVectorModel>()
                        .selectVector(VectorSelectionType.base, value),
                    itemBuilder: (context) => <PopupMenuItem<int>>[
                      for (var i = 0; i < vectors.length; i++)
                        CheckedPopupMenuItem<int>(
                          value: i,
                          checked: getIt<CalcVectorModel>()
                              .isChecked(VectorSelectionType.base, i),
                          child: Text('v$i'),
                        ),
                    ],
                    child: vectorSelectionString(baseSelection),
                    tooltip: "Zvolte vektory generující bázi",
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
                              showSnackBarMessage(
                                context,
                                e.friendlyMessage,
                              );
                            } on ExpressionException catch (e) {
                              var calcException = CalcExpressionException
                                  .fromExpressionException(null, e);
                              showSnackBarMessage(
                                context,
                                calcException.friendlyMessage,
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
              style: Theme.of(context).textTheme.headlineMedium!,
            ),
            const SizedBox(height: 12),
            ListView.separated(
              itemBuilder: (context, index) => SolutionView(
                key: ValueKey(solutions[index]),
                solution: solutions[index],
                onSelected: (option) {
                  if (option == SolutionOptions.remove) {
                    getIt<CalcSolutionsModel>().removeSolution(
                      CalcCategory.vectorSpace,
                      index,
                    );
                  }
                },
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: solutions.length,
              reverse: true,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
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

    const String coordsToTransform = "Souřadnice:";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Transformace souřadnic',
                style: Theme.of(context).textTheme.headlineSmall!,
              ),
              const SizedBox(width: 8),
              const Hint("Výpočet transformace souřadnic od báze A k bázi B"),
              const SizedBox(width: 8),
              InfoButton(refName: PredefinedRef.transformMatrix.refName),
            ],
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
                      .selectVector(VectorSelectionType.transformA, value),
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
                  child: vectorSelectionString(transformA),
                  tooltip: "Zvolte vektory báze A",
                ),
                const SizedBox(width: 8.0),
                StyledPopupButton<int>(
                  onSelected: (value) => getIt<CalcVectorModel>()
                      .selectVector(VectorSelectionType.transformB, value),
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
                  child: vectorSelectionString(transformB),
                  tooltip: "Zvolte vektory báze B",
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
              BlockRefButton(
                refName: PredefinedRef.transformCoords.refName,
                placeholder: coordsToTransform,
                text: coordsToTransform,
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
                          showSnackBarMessage(context, e.friendlyMessage);
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
        basisA: ExpressionSet(items: basisA.map((e) => e.toVector()).toSet()),
        basisB: ExpressionSet(items: basisB.map((e) => e.toVector()).toSet()),
      ));
    } on CalcExpressionException catch (e) {
      showSnackBarMessage(context, e.friendlyMessage);
    } on ExpressionException catch (e) {
      var calcException =
          CalcExpressionException.fromExpressionException(null, e);
      showSnackBarMessage(
        context,
        calcException.friendlyMessage,
      );
    }
    return null;
  }
}
