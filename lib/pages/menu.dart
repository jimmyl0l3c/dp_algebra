import 'package:dp_algebra/routing/route_state.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lineární Algebra - Menu'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            children: [
              ElevatedButton(
                onPressed: () {
                  routeState.go('/chapter');
                },
                child: const Text('Výuka'),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  routeState.go('/exercise');
                },
                child: const Text('Procvičování'),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                  onPressed: () {
                    routeState.go('/calc');
                  },
                  child: const Text('Kalkulačka')),
            ],
          ),
        ),
      ),
    );
  }
}
