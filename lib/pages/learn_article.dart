import 'package:dp_algebra/models/learn_article.dart';
import 'package:dp_algebra/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';

class LearnArticle extends StatelessWidget {
  final Future<LArticle?> article;

  const LearnArticle({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Test',
      child: Container(),
    );
  }
}
