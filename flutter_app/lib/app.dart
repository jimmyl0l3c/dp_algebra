import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages/navigator.dart';
import 'routing/delegate.dart';
import 'routing/parser.dart';
import 'routing/route_state.dart';
import 'theme.dart';

class AlgebraApp extends StatefulWidget {
  const AlgebraApp({Key? key}) : super(key: key);

  @override
  State<AlgebraApp> createState() => _AlgebraAppState();
}

class _AlgebraAppState extends State<AlgebraApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final RouteState _routeState;
  late final MainRouterDelegate _routerDelegate;
  late final RouteParser _routeParser;

  @override
  void initState() {
    _routeParser = RouteParser(
      allowedPaths: [
        '/',
        '/chapter',
        '/chapter/:chapterId',
        '/chapter/:chapterId/:articleId',
        '/chapter/:chapterId/:articleId/:pageId',
        '/exercise',
        '/exercise/:sectionChapterId',
        '/exercise/:sectionChapterId/:sectionPageId',
        '/calc',
        '/calc/:sectionChapterId',
        '/calc/:sectionChapterId/:sectionPageId'
      ],
    );

    _routeState = RouteState(_routeParser);

    _routerDelegate = MainRouterDelegate(
      routeState: _routeState,
      builder: (context) => AlgebraNavigator(
        navigatorKey: _navigatorKey,
      ),
      navigatorKey: _navigatorKey,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) => RouteStateScope(
        notifier: _routeState,
        child: MaterialApp.router(
          title: 'Lineární Algebra',
          routeInformationParser: _routeParser,
          routerDelegate: _routerDelegate,
          theme: algebraTheme,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('cs'),
          ],
        ),
      );

  @override
  void dispose() {
    _routeState.dispose();
    _routerDelegate.dispose();
    super.dispose();
  }
}
