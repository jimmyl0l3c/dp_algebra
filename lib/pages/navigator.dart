import 'package:flutter/material.dart';

import '../routing/route_state.dart';
import 'calc_menu.dart';
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
  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final pathTemplate = routeState.route.pathTemplate;

    if (pathTemplate == '/chapter/:chapterId') {
      // find chapter
    }

    if (pathTemplate == '/exercise/:exerciseId') {
      // find exercise
    }

    return Navigator(
      key: widget.navigatorKey,
      onPopPage: (route, dynamic result) {
        return route.didPop(result);
      },
      pages: [
        if (routeState.route.pathTemplate == '/')
          const MaterialPage(
            child: Menu(),
          )
        else if (routeState.route.pathTemplate == '/calc')
          const MaterialPage(
            child: CalcMenu(),
          )
        else
          const MaterialPage(child: Text('Unimplemented')),
      ],
    );
  }
}
