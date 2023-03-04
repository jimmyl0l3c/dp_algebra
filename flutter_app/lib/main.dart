import 'package:dp_algebra/app.dart';
import 'package:dp_algebra/data/db_service.dart';
import 'package:dp_algebra/models/calc_state/calc_equation_model.dart';
import 'package:dp_algebra/models/calc_state/calc_equation_solutions_model.dart';
import 'package:dp_algebra/models/calc_state/calc_matrix_model.dart';
import 'package:dp_algebra/models/calc_state/calc_matrix_solutions_model.dart';
import 'package:dp_algebra/models/calc_state/calc_vector_model.dart';
import 'package:dp_algebra/models/calc_state/calc_vector_solutions_model.dart';
import 'package:dp_algebra/models/calc_state_n/calc_matrix_solutions_model.dart';
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
  getIt.registerSingleton<CalcMatrixSolutionsModel2>(
      CalcMatrixSolutionsModel2());
  getIt.registerSingleton<CalcEquationModel>(CalcEquationModel());
  getIt.registerSingleton<CalcEquationSolutionsModel>(
      CalcEquationSolutionsModel());
  getIt.registerSingleton<CalcVectorModel>(CalcVectorModel());
  getIt.registerSingleton<CalcVectorSolutionsModel>(CalcVectorSolutionsModel());

  getIt.registerSingleton<DbService>(DbService());
}
