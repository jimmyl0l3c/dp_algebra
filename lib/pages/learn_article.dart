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
    return FutureBuilder<LArticle?>(
        future: article,
        builder: (context, snapshot) {
          Widget? body;
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              body = Container();
            } else {
              body = const Text('No pages found');
            }
          } else {
            body = const Text('Loading...');
          }

          return MainScaffold(
            title: snapshot.hasData && snapshot.data != null
                ? snapshot.data!.title
                : 'Loading ...',
            child: body,
          );
        });
  }
}
