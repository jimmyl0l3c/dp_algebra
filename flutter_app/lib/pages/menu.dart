import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
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
                    context.go('/chapter');
                  },
                  child: const Text('Výuka'),
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/exercise');
                  },
                  child: const Text('Procvičování'),
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      context.go('/calc');
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
