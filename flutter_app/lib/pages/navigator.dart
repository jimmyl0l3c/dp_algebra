import 'package:dp_algebra/data/calc_data.dart';
import 'package:dp_algebra/data/db_service.dart';
import 'package:dp_algebra/data/exercise_data.dart';
import 'package:dp_algebra/models/app_pages/section_chapter.dart';
import 'package:dp_algebra/models/app_pages/section_page.dart';
import 'package:dp_algebra/models/db/learn_article.dart';
import 'package:dp_algebra/models/db/learn_chapter.dart';
import 'package:dp_algebra/pages/generic/alg_chapter_view.dart';
import 'package:dp_algebra/pages/generic/alg_menu_view.dart';
import 'package:dp_algebra/pages/generic/alg_page_view.dart';
import 'package:dp_algebra/pages/learn/learn_article.dart';
import 'package:dp_algebra/pages/learn/learn_chapter.dart';
import 'package:dp_algebra/pages/learn/learn_menu.dart';
import 'package:dp_algebra/pages/menu.dart';
import 'package:dp_algebra/pages/transition_page.dart';
import 'package:dp_algebra/routing/route_state.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
  final _calcChapterKey = const ValueKey('Calculator chapter key');
  final _calcPageKey = const ValueKey('Calculator page key');
  final _exerciseKey = const ValueKey('Exercise key');
  final _exerciseChapterKey = const ValueKey('Exercise chapter key');
  final _exercisePageKey = const ValueKey('Exercise page key');

  final DbService _dbService = GetIt.instance.get<DbService>();

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
          ? _dbService.fetchChapter(currentChapterId)
          : null;

      if (pathTemplate.startsWith('/chapter/:chapterId/:articleId')) {
        currentArticleId =
            int.tryParse(routeState.route.parameters['articleId']!);
        currentArticle = currentArticleId != null
            ? _dbService.fetchArticle(currentArticleId)
            : null;

        if (pathTemplate.startsWith('/chapter/:chapterId/:articleId/:pageId')) {
          currentPageId = int.tryParse(routeState.route.parameters['pageId']!);
        }
      }
    }

    int? sectionChapterId, sectionPageId;
    if (pathTemplate.contains('/:sectionChapterId')) {
      sectionChapterId =
          int.tryParse(routeState.route.parameters['sectionChapterId']!);

      if (pathTemplate.contains('/:sectionChapterId/:sectionPageId')) {
        sectionPageId =
            int.tryParse(routeState.route.parameters['sectionPageId']!);
      }
    }

    SectionChapterModel? exerciseChapter;
    SectionPageModel? exercisePage;
    if (pathTemplate.startsWith('/exercise/') &&
        sectionChapterId != null &&
        sectionChapterId < ExerciseData.chapters.length) {
      exerciseChapter = ExerciseData.chapters[sectionChapterId];

      if (sectionPageId != null &&
          sectionPageId < exerciseChapter.pages.length) {
        exercisePage = exerciseChapter.pages[sectionPageId];
      }
    }

    SectionChapterModel? calcChapter;
    SectionPageModel? calcPage;
    if (pathTemplate.startsWith('/calc/') &&
        sectionChapterId != null &&
        sectionChapterId < CalcData.chapters.length) {
      calcChapter = CalcData.chapters[sectionChapterId];

      if (sectionPageId != null && sectionPageId < calcChapter.pages.length) {
        calcPage = calcChapter.pages[sectionPageId];
      }
    }

    return Navigator(
      key: widget.navigatorKey,
      onPopPage: (route, dynamic result) {
        if (route.settings is Page) {
          if ((route.settings as Page).key == _calcChapterKey) {
            routeState.go('/calc');
          } else if ((route.settings as Page).key == _calcPageKey) {
            routeState.go('/calc/$sectionChapterId');
          } else if ((route.settings as Page).key == _chapterKey) {
            routeState.go('/chapter');
          } else if ((route.settings as Page).key == _articleKey) {
            routeState.go('/chapter/$currentChapterId');
          } else if ((route.settings as Page).key == _exerciseChapterKey) {
            routeState.go('/exercise');
          } else if ((route.settings as Page).key == _exercisePageKey) {
            routeState.go('/exercise/$sectionChapterId');
          }
        }

        return route.didPop(result);
      },
      pages: [
        AlgebraTransitionPage(
          key: _menuKey,
          child: const Menu(),
        ),
        if (routeState.route.pathTemplate.startsWith('/calc'))
          AlgebraTransitionPage(
            key: _calcKey,
            child: AlgMenuView(
              sectionTitle: 'Kalkulačka',
              sectionPath: 'calc',
              chapters: CalcData.chapters,
            ),
          )
        else if (routeState.route.pathTemplate.startsWith('/chapter'))
          AlgebraTransitionPage(
            key: _chapterMenuKey,
            child: const LearnMenu(),
          )
        else if (routeState.route.pathTemplate.startsWith('/exercise'))
          AlgebraTransitionPage(
            key: _exerciseKey,
            child: AlgMenuView(
              sectionTitle: 'Procvičování',
              sectionPath: 'exercise',
              chapters: ExerciseData.chapters,
            ),
          ),

        if (currentChapter != null)
          AlgebraTransitionPage(
            key: _chapterKey,
            child: LearnChapter(chapter: currentChapter),
          ),
        if (currentChapterId != null && currentArticle != null)
          AlgebraTransitionPage(
            key: _articleKey,
            child: LearnArticle(
              currentChapter: currentChapterId,
              article: currentArticle,
              currentPage: currentPageId ?? 1,
            ),
          ),
        // Add page to stack if /exercise/:exerciseChapterId
        if (exerciseChapter != null && sectionChapterId != null)
          AlgebraTransitionPage(
            key: _exerciseChapterKey,
            child: AlgChapterView(
              sectionTitle: 'Procvičování',
              chapter: exerciseChapter,
              chapterId: sectionChapterId,
            ),
          ),
        if (exerciseChapter != null && exercisePage != null)
          AlgebraTransitionPage(
            key: _exercisePageKey,
            child: AlgPageView(
              sectionTitle: 'Procvičování',
              chapter: exerciseChapter,
              page: exercisePage,
            ),
          ),
        // Add page to stack if /calc/:calcId
        if (calcChapter != null && sectionChapterId != null)
          AlgebraTransitionPage(
            key: _calcChapterKey,
            child: AlgChapterView(
              sectionTitle: 'Kalkulačka',
              chapter: calcChapter,
              chapterId: sectionChapterId,
            ),
          ),
        if (calcChapter != null && calcPage != null)
          AlgebraTransitionPage(
            key: _calcPageKey,
            child: AlgPageView(
              sectionTitle: 'Kalkulačka',
              chapter: calcChapter,
              page: calcPage,
            ),
          ),
      ],
    );
  }
}
