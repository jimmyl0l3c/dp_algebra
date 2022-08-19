import 'package:flutter/material.dart';

import '../routing/route_state.dart';
import 'calc_matrices.dart';
import 'menu.dart';
import 'section_menu.dart';

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
  final _chapterKey = const ValueKey('Learn chapter key');
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
        else if (routeState.route.pathTemplate.startsWith('/calc'))
          MaterialPage(
            key: _calcKey,
            child: SectionMenu(
              title: 'Kalkulačka',
              sections: [
                Section(
                    title: 'Operace s maticemi',
                    subtitle:
                        'Součet, rozdíl, součin, vlastnosti matic (hodnost, determinant)',
                    path: '/calc/0'),
                Section(title: 'Soustavy lineárních rovnic'),
                Section(
                  title: 'Vektorové prostory',
                  subtitle:
                      'Lineární (ne)závislost vektorů, nalezení báze, transformace souřadnic od báze k bázi, ...',
                ),
              ],
            ),
          )
        else if (routeState.route.pathTemplate.startsWith('/chapter'))
          MaterialPage(
            key: _chapterKey,
            child: const SectionMenu(
              title: 'Výuka - Výběr kapitoly',
              sections: [],
            ),
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
