import 'package:dp_algebra/models/db/learn_block.dart';
import 'package:dp_algebra/models/db/learn_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class LPageView extends StatelessWidget {
  final LPage page;

  const LPageView({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: page.blocks.length,
      itemBuilder: (context, index) {
        LBlock block = page.blocks[index];

        bool isMath = false;
        bool isDisplayMath = false;
        List<List<Widget>> pieces = [[]];
        for (var segment in block.content
            .substring(block.content.indexOf(';') + 1)
            .split(r'$')) {
          if (segment.isEmpty) {
            isDisplayMath = !isDisplayMath;
            continue;
          }

          if (isMath) {
            if (isDisplayMath) pieces.add([]);

            pieces[pieces.length - 1].add(Math.tex(
              segment,
              textScaleFactor: isDisplayMath ? 1.4 : 1.1,
              mathStyle: isDisplayMath ? MathStyle.display : MathStyle.text,
            ));

            if (isDisplayMath) pieces.add([]);
          } else {
            pieces[pieces.length - 1].add(Text(
              segment,
              style: Theme.of(context).textTheme.bodyText2,
            ));
          }

          isMath = !isMath;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: [
              if (block.type.title != null)
                Text(
                  block.type.title!,
                  style: Theme.of(context).textTheme.headline3,
                ),
              for (var row in pieces) _getBlockWrap(row)
            ],
          ),
        );
      },
    );
  }

  Widget _getBlockWrap(List<Widget> elements) => Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 8.0,
        children: elements,
      );
}
