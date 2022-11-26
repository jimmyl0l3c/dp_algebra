import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:dp_algebra/pages/navigator.dart';
import 'package:dp_algebra/routing/delegate.dart';
import 'package:dp_algebra/routing/parser.dart';
import 'package:dp_algebra/routing/route_state.dart';
import 'package:dp_algebra/secrets.dart';
import 'package:dp_algebra/theme.dart';
import 'package:flutter/material.dart';

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
        navigatorKey: _navigatorKey);

    Backendless.setUrl('https://eu-api.backendless.com');
    Backendless.initApp(
      applicationId: AlgebraSecrets.applicationId,
      jsApiKey: AlgebraSecrets.jsApiKey,
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
        ),
      );

  @override
  void dispose() {
    _routeState.dispose();
    _routerDelegate.dispose();
    super.dispose();
  }
}
