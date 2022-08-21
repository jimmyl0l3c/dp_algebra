import 'package:dp_algebra/pages/learn_chapter.dart';
import 'package:flutter/material.dart';

import '../dev.dart';
import '../models/learn_chapter.dart';
import '../routing/route_state.dart';
import 'calc_matrices.dart';
import 'calc_menu.dart';
import 'learn_menu.dart';
import 'menu.dart';

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
  final _calcKey = const ValueKey('Calculator key');
  final _calcSectionKey = const ValueKey('Calculator section key');
  final _tempKey = const ValueKey('Temporary unimplemented key');

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final pathTemplate = routeState.route.pathTemplate;

    LChapter? currentChapter;
    if (pathTemplate == '/chapter/:chapterId') {
      int? chapterId = int.tryParse(routeState.route.parameters['chapterId']!);
      // TODO: obtain data from db
      currentChapter = Dev.learnData.firstWhere((c) => c.id == chapterId);
    }

    if (pathTemplate == '/exercise/:exerciseId') {
      // find exercise
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
            routeState.go('/calc');
          } else if ((route.settings as Page).key == _chapterKey) {
            routeState.go('/chapter');
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
        else
          MaterialPage(
            key: _tempKey,
            child: const Text('Unimplemented'),
          ),

        if (currentChapter != null)
          MaterialPage(
            key: _chapterKey,
            child: LearnChapter(chapter: currentChapter),
          ),
        // Add page to stack if /calc/:calcId
        if (calcId == '0')
          MaterialPage(
            key: _calcSectionKey,
            child: const CalcMatrices(),
          ),
      ],
    );
  }
}
