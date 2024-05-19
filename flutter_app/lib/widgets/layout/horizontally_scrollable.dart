import 'package:flutter/material.dart';

class HorizontallyScrollable extends StatelessWidget {
  final Widget child;

  const HorizontallyScrollable({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return Scrollbar(
      thumbVisibility: true,
      interactive: true,
      controller: scrollController,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.only(bottom: 12.0),
        child: child,
      ),
    );
  }
}
