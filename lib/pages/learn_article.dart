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
          String title = 'Loading...';
          if (snapshot.hasData) {
            title = snapshot.data!.title;
            body = Container();
          } else {
            if (snapshot.connectionState == ConnectionState.waiting) {
              body = const Text('Loading...');
            } else {
              title = 'Article 404';
              body = const Text('Article not found');
            }
          }

          return MainScaffold(
            title: title,
            child: body,
          );
        });
  }
}
