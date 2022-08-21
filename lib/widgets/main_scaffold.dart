import 'package:flutter/material.dart';

import '../routing/route_state.dart';

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget? child;
  final bool isSectionRoot;

  const MainScaffold({
    Key? key,
    required this.title,
    this.child,
    this.isSectionRoot = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: isSectionRoot
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  routeState.go('/');
                },
              )
            : null,
      ),
      body: child,
    );
  }
}
