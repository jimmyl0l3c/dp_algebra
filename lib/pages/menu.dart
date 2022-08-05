import 'package:flutter/material.dart';

import '../routing/route_state.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Linear Algebra - Menu'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            children: [
              const ElevatedButton(
                onPressed: null,
                child: Text('Learn'),
              ),
              const SizedBox(height: 8.0),
              const ElevatedButton(
                onPressed: null,
                child: Text('Exercise'),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                  onPressed: () {
                    routeState.go('/calc');
                  },
                  child: const Text('Calculator')),
            ],
          ),
        ),
      ),
    );
  }
}