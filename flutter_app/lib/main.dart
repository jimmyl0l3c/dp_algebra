import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app.dart';
import 'data/db_service.dart';
import 'models/calc_state/calc_equation_model.dart';
import 'models/calc_state/calc_matrix_model.dart';
import 'models/calc_state/calc_solutions_model.dart';
import 'models/calc_state/calc_vector_model.dart';
import 'router.dart';

final getIt = GetIt.instance;
final logger = Logger();

void main() {
  setHashUrlStrategy();

  setup();
  runApp(const AlgebraApp());
}

void setup() {
  getIt.registerSingleton<CalcSolutionsModel>(CalcSolutionsModel());

  getIt.registerSingleton<CalcMatrixModel>(CalcMatrixModel());
  getIt.registerSingleton<CalcEquationModel>(CalcEquationModel());
  getIt.registerSingleton<CalcVectorModel>(CalcVectorModel());

  getIt.registerSingleton<DbService>(DbService());

  getIt.registerSingleton<AlgebraRouter>(AlgebraRouter());
}
