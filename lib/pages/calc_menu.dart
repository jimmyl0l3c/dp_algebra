import 'package:flutter/material.dart';

import '../routing/route_state.dart';

class CalcMenu extends StatelessWidget {
  const CalcMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulačka'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            routeState.go('/');
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 8.0,
        ),
        children: [
          TextButton(
            onPressed: () {},
            child: const ListTile(
              title: Text('Operace s maticemi'),
              subtitle: Text(
                  'Součet, rozdíl, součin, vlastnosti matic (hodnost, determinant)'),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const ListTile(
              title: Text('Soustavy lineárních rovnic'),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const ListTile(
              title: Text('Vektorové prostory'),
              subtitle: Text(
                  'Lineární (ne)závislost vektorů, nalezení báze, transformace souřadnic od báze k bázi, ...'),
            ),
          ),
        ],
      ),
    );
  }
}
