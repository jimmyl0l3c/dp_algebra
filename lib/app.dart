import 'package:flutter/material.dart';

import 'pages/navigator.dart';
import 'routing/delegate.dart';
import 'routing/parser.dart';
import 'routing/route_state.dart';

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
        '/chapters',
        '/chapter/:chapterId',
        '/exercise',
        '/exercise/:exerciseId',
        '/calc',
      ],
    );

    _routeState = RouteState(_routeParser);

    _routerDelegate = MainRouterDelegate(
        routeState: _routeState,
        builder: (context) => AlgebraNavigator(
              navigatorKey: _navigatorKey,
            ),
        navigatorKey: _navigatorKey);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => RouteStateScope(
        notifier: _routeState,
        child: MaterialApp.router(
          routeInformationParser: _routeParser,
          routerDelegate: _routerDelegate,
          theme: ThemeData(),
        ),
      );

  @override
  void dispose() {
    _routeState.dispose();
    _routerDelegate.dispose();
    super.dispose();
  }
}