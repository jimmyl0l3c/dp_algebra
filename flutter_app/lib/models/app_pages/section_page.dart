import 'package:flutter/material.dart';

class SectionPageModel {
  final String title;
  final String? subtitle;
  final Widget page;

  const SectionPageModel({
    required this.title,
    this.subtitle,
    required this.page,
  });
}
