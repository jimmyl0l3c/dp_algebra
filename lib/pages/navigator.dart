import 'package:dp_algebra/data/calc_data_controller.dart';
import 'package:dp_algebra/data/db_helper.dart';
import 'package:dp_algebra/models/learn_article.dart';
import 'package:dp_algebra/models/learn_chapter.dart';
import 'package:dp_algebra/pages/calc/calc_equations.dart';
import 'package:dp_algebra/pages/calc/calc_matrices.dart';
import 'package:dp_algebra/pages/calc/calc_menu.dart';
import 'package:dp_algebra/pages/exercise/exercise_chapter.dart';
import 'package:dp_algebra/pages/exercise/exercise_menu.dart';
import 'package:dp_algebra/pages/exercise/exercise_page.dart';
import 'package:dp_algebra/pages/learn/learn_article.dart';
import 'package:dp_algebra/pages/learn/learn_chapter.dart';
import 'package:dp_algebra/pages/learn/learn_menu.dart';
import 'package:dp_algebra/pages/menu.dart';
import 'package:dp_algebra/routing/route_state.dart';
import 'package:flutter/material.dart';

class AlgebraNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const AlgebraNavigator({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  State<AlgebraNavigator> createState() => _AlgebraNavigatorState();
}

class _AlgebraNavigatorState extends State<AlgebraNavigator> {
  final _menuKey = const ValueKey('Main menu key');
  final _chapterMenuKey = const ValueKey('Learn chapter menu key');
  final _chapterKey = const ValueKey('Learn chapter key');
  final _articleKey = const ValueKey('Learn article key');
  final _calcKey = const ValueKey('Calculator key');
  final _calcSectionKey = const ValueKey('Calculator section key');
  final _exerciseKey = const ValueKey('Exercise key');
  final _exerciseChapterKey = const ValueKey('Exercise chapter key');
  final _exercisePageKey = const ValueKey('Exercise page key');

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final pathTemplate = routeState.route.pathTemplate;

    int? currentChapterId;
    int? currentArticleId;
    int? currentPageId;
    Future<LChapter?>? currentChapter;
    Future<LArticle?>? currentArticle;
    if (pathTemplate.startsWith('/chapter/:chapterId')) {
      currentChapterId =
          int.tryParse(routeState.route.parameters['chapterId']!);
      currentChapter = currentChapterId != null
          ? DbHelper.findChapter(currentChapterId)
          : null;

      if (pathTemplate.startsWith('/chapter/:chapterId/:articleId')) {
        currentArticleId =
            int.tryParse(routeState.route.parameters['articleId']!);
        currentArticle = currentChapterId != null && currentArticleId != null
            ? DbHelper.findArticle(currentChapterId, currentArticleId)
            : null;

        if (pathTemplate.startsWith('/chapter/:chapterId/:articleId/:pageId')) {
          currentPageId = int.tryParse(routeState.route.parameters['pageId']!);
          // TODO: obtain page
        }
      }
    }

    String? exerciseChapterId, exercisePageId;
    if (pathTemplate.startsWith('/exercise/:exerciseChapterId')) {
      exerciseChapterId = routeState.route.parameters['exerciseChapterId'];

      if (pathTemplate == '/exercise/:exerciseChapterId/:exercisePageId') {
        exercisePageId = routeState.route.parameters['exercisePageId'];
      }
    }

    String? calcId;
    if (pathTemplate == '/calc/:calcId') {
      calcId = routeState.route.parameters['calcId'];
    }

    return Navigator(
      key: widget.navigatorKey,
      onPopPage: (route, dynamic result) {
        if (route.settings is Page) {
          if ((route.settings as Page).key == _calcSectionKey) {
            CalcDataController.dispose();
            routeState.go('/calc');
          } else if ((route.settings as Page).key == _chapterKey) {
            routeState.go('/chapter');
          } else if ((route.settings as Page).key == _articleKey) {
            routeState.go('/chapter/$currentChapterId');
          } else if ((route.settings as Page).key == _exerciseChapterKey) {
            routeState.go('/exercise');
          } else if ((route.settings as Page).key == _exercisePageKey) {
            routeState.go('/exercise/$exerciseChapterId');
          }
        }

        return route.didPop(result);
      },
      pages: [
        if (routeState.route.pathTemplate == '/')
          MaterialPage(
            key: _menuKey,
            child: const Menu(),
          )
        else if (routeState.route.pathTemplate.startsWith('/calc'))
          MaterialPage(
            key: _calcKey,
            child: const CalcMenu(),
          )
        else if (routeState.route.pathTemplate.startsWith('/chapter'))
          MaterialPage(
            key: _chapterMenuKey,
            child: const LearnMenu(),
          )
        else if (routeState.route.pathTemplate.startsWith('/exercise'))
          MaterialPage(
            key: _exerciseKey,
            child: const ExerciseMenu(),
          ),

        if (currentChapter != null)
          MaterialPage(
            key: _chapterKey,
            child: LearnChapter(chapter: currentChapter),
          ),
        if (currentArticle != null)
          MaterialPage(
            key: _articleKey,
            child: LearnArticle(article: currentArticle),
          ),
        // Add page to stack if /exercise/:exerciseChapterId
        if (exerciseChapterId != null)
          MaterialPage(
            key: _exerciseChapterKey,
            child: ExerciseChapter(chapterId: exerciseChapterId),
          ),
        if (exercisePageId != null)
          MaterialPage(
            key: _exercisePageKey,
            child: ExercisePage(
              chapterId: exerciseChapterId!,
              pageId: exercisePageId,
            ),
          ),
        // Add page to stack if /calc/:calcId
        if (calcId == '0')
          MaterialPage(
            key: _calcSectionKey,
            child: const CalcMatrices(),
          ),
        if (calcId == '1')
          MaterialPage(
            key: _calcSectionKey,
            child: const CalcEquations(),
          ),
      ],
    );
  }
}
