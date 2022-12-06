import 'package:dp_algebra/app.dart';
import 'package:dp_algebra/models/calc_state/calc_matrix_model.dart';
import 'package:dp_algebra/models/calc_state/calc_matrix_solutions_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_strategy/url_strategy.dart';

final getIt = GetIt.instance;

void main() {
  setHashUrlStrategy();

  setup();
  runApp(const AlgebraApp());
}

void setup() {
  getIt.registerSingleton<CalcMatrixModel>(CalcMatrixModel());
  getIt.registerSingleton<CalcMatrixSolutionsModel>(CalcMatrixSolutionsModel());
}
