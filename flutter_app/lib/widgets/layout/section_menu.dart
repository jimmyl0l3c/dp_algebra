import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Section {
  final String title;
  final String? subtitle;
  final String? path;

  Section({required this.title, this.subtitle, this.path});
}

class SectionMenu extends StatelessWidget {
  final List<Section> sections;

  const SectionMenu({
    super.key,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          itemCount: sections.length,
          itemBuilder: (context, i) {
            Section section = sections[i];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: ElevatedButton(
                onPressed: section.path == null
                    ? null
                    : () {
                        context.go(section.path!);
                      },
                child: ListTile(
                  title: Text(section.title),
                  subtitle:
                      section.subtitle == null ? null : Text(section.subtitle!),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
