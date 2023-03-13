import 'package:flutter/material.dart';

class SectionPageModel {
  String title;
  String? subtitle;
  Widget page;

  SectionPageModel({
    required this.title,
    this.subtitle,
    required this.page,
  });
}
