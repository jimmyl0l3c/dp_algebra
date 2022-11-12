import 'package:flutter/material.dart';

class ExercisePageModel {
  String title;
  String? subtitle;
  Widget page;

  ExercisePageModel({required this.title, this.subtitle, required this.page});
}
