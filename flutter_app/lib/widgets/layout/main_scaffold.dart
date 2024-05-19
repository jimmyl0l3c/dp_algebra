import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget? child;
  final bool isSectionRoot;
  final Widget? floatingActionButton;

  const MainScaffold({
    Key? key,
    required this.title,
    this.child,
    this.isSectionRoot = false,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: isSectionRoot
            ? BackButton(
                onPressed: () {
                  context.go('/');
                },
              )
            : null,
        actions: [
          IconButton(
            tooltip: 'Návrat do hlavního menu',
            onPressed: () {
              context.go('/');
            },
            icon: const Icon(Icons.home),
          )
        ],
      ),
      body: child,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
