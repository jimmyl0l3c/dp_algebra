import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class DisplayMathWrap extends StatelessWidget {
  final String content;
  final Widget? citation;

  const DisplayMathWrap({
    Key? key,
    required this.content,
    this.citation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mathParts = Math.tex(
      content,
      textScaleFactor: 1.4,
      mathStyle: MathStyle.display,
    ).texBreak().parts.toList();

    var lastMath = mathParts.removeLast();

    List<Widget> wrapItems = [
      ...mathParts,
      if (citation != null)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            lastMath,
            const SizedBox(width: 8),
            citation!,
          ],
        ),
      if (citation == null) lastMath,
    ];

    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.center,
      runSpacing: 8.0,
      children: wrapItems,
    );
  }
}
