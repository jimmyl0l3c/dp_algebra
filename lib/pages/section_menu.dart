import 'package:flutter/material.dart';

import '../routing/route_state.dart';

class Section {
  final String title;
  final String? subtitle;
  final String? path;

  Section({required this.title, this.subtitle, this.path});
}

class SectionMenu extends StatelessWidget {
  final String title;
  final List<Section> sections;

  const SectionMenu({
    Key? key,
    required this.title,
    required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            routeState.go('/');
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 8.0,
        ),
        itemCount: sections.length,
        itemBuilder: (context, i) {
          Section section = sections[i];
          return TextButton(
            onPressed: section.path == null
                ? null
                : () {
                    routeState.go(section.path!);
                  },
            child: ListTile(
              title: Text(section.title),
              subtitle:
                  section.subtitle == null ? null : Text(section.subtitle!),
            ),
          );
        },
      ),
    );
  }
}
