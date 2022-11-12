import 'package:dp_algebra/models/learn_page.dart';
import 'package:flutter/material.dart';

class LPageView extends StatelessWidget {
  final LPage page;

  const LPageView({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: page.blocks.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 100,
          child: Center(child: Text(page.blocks[index].content)),
        );
      },
    );
  }
}
