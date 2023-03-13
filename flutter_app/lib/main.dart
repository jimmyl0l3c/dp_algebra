import 'package:dp_algebra/app.dart';
import 'package:dp_algebra/data/db_service.dart';
import 'package:dp_algebra/models/calc_state/calc_equation_model.dart';
import 'package:dp_algebra/models/calc_state/calc_matrix_model.dart';
import 'package:dp_algebra/models/calc_state/calc_solutions_model.dart';
import 'package:dp_algebra/models/calc_state/calc_vector_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:url_strategy/url_strategy.dart';

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
}
