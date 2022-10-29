import 'package:flutter/material.dart';

import '../models/learn_page.dart';

class LPageView extends StatelessWidget {
  final LPage page;

  const LPageView({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('id: ${page.id}');
  }
}
