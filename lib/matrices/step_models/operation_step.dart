import 'package:dp_algebra/matrices/step_models/primitive_operation.dart';

class OperationStep {
  List<PrimitiveOperation> operations;
  dynamic result;

  OperationStep({required this.operations, required this.result});
}
