import 'package:flutter/material.dart';

import '../models/learn_chapter.dart';
import '../widgets/main_scaffold.dart';

class LearnChapter extends StatelessWidget {
  final LChapter chapter;

  const LearnChapter({
    Key? key,
    required this.chapter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: chapter.title,
      child: Container(),
    );
  }
}
