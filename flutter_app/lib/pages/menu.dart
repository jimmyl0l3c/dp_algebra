import 'package:flutter/material.dart';

import '../routing/route_state.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lineární algebra \u2014 menu'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            children: [
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    routeState.go('/chapter');
                  },
                  child: const Text('Výuka'),
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    routeState.go('/exercise');
                  },
                  child: const Text('Procvičování'),
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      routeState.go('/calc');
                    },
                    child: const Text('Kalkulačka')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
