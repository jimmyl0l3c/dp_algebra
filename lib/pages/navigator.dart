import 'package:flutter/material.dart';

import '../routing/route_state.dart';
import 'calc_matrices.dart';
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
  final _menuKey = const ValueKey('Main menu key');
  final _calcKey = const ValueKey('Calculator key');
  final _calcSectionKey = const ValueKey('Calculator section key');
  final _tempKey = const ValueKey('Temporary unimplemented key');

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

    String? calcId;
    if (pathTemplate == '/calc/:calcId') {
      calcId = routeState.route.parameters['calcId'];
    }

    return Navigator(
      key: widget.navigatorKey,
      onPopPage: (route, dynamic result) {
        if (route.settings is Page &&
            (route.settings as Page).key == _calcSectionKey) {
          routeState.go('/calc');
        }

        return route.didPop(result);
      },
      pages: [
        if (routeState.route.pathTemplate == '/')
          MaterialPage(
            key: _menuKey,
            child: const Menu(),
          )
        else if (routeState.route.pathTemplate == '/calc' ||
            routeState.route.pathTemplate == '/calc/:calcId')
          MaterialPage(
            key: _calcKey,
            child: const CalcMenu(),
          )
        else
          MaterialPage(
            key: _tempKey,
            child: const Text('Unimplemented'),
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
