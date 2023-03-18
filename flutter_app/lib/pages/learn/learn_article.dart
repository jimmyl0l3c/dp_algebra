import 'package:dp_algebra/models/db/learn_article.dart';
import 'package:dp_algebra/models/db/learn_page.dart';
import 'package:dp_algebra/routing/route_state.dart';
import 'package:dp_algebra/widgets/layout/main_scaffold.dart';
import 'package:dp_algebra/widgets/loading.dart';
import 'package:dp_algebra/widgets/lpage_view.dart';
import 'package:flutter/material.dart';

class LearnArticle extends StatelessWidget {
  final Future<LArticle?> article;
  final int currentChapter;
  final int currentPage;

  const LearnArticle({
    Key? key,
    required this.currentChapter,
    this.currentPage = 1,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    return FutureBuilder<LArticle?>(
        future: article,
        builder: (context, snapshot) {
          Widget? body;
          String title = 'Načítání...';
          Widget? forwardButton;
          Widget? backwardButton;
          Widget? floatingButton;

          if (snapshot.hasData) {
            title = snapshot.data!.title;

            List<LPage> pages = snapshot.data!.pages;

            if (pages.length >= currentPage + 1) {
              forwardButton = FloatingActionButton(
                onPressed: () {
                  routeState.go(
                    '/chapter/$currentChapter/${snapshot.data!.id}/${currentPage + 1}',
                  );
                },
                child: const Icon(
                  Icons.arrow_forward,
                  size: 40,
                ),
              );
            }

            if (currentPage > 1) {
              backwardButton = FloatingActionButton(
                onPressed: () {
                  routeState.go(
                    '/chapter/1/${snapshot.data!.id}/${currentPage - 1}',
                  );
                },
                child: const Icon(
                  Icons.arrow_back,
                  size: 40,
                ),
              );
            }

            if (backwardButton != null || forwardButton != null) {
              floatingButton = Stack(
                fit: StackFit.expand,
                children: [
                  if (backwardButton != null)
                    Positioned(
                      right: 100,
                      bottom: 20,
                      child: backwardButton,
                    ),
                  if (forwardButton != null)
                    Positioned(
                      right: 30,
                      bottom: 20,
                      child: forwardButton,
                    ),
                ],
              );
            }

            body = Container(
              child: pages.isEmpty
                  ? const Center(child: Text('Článek je prázdný'))
                  : LPageView(page: pages[currentPage - 1]),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.waiting) {
              body = const Loading();
            } else {
              title = 'Error';
              body = const Center(child: Text('Článek nenalezen'));
            }
          }

          return MainScaffold(
            title: title,
            floatingActionButton: floatingButton,
            child: body,
          );
        });
  }
}
