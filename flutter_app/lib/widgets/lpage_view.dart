import 'package:dp_algebra/data/block_parser.dart';
import 'package:dp_algebra/data/db_service.dart';
import 'package:dp_algebra/models/db/learn_block.dart';
import 'package:dp_algebra/models/db/learn_page.dart';
import 'package:dp_algebra/models/db/learn_ref.dart';
import 'package:dp_algebra/models/learn/block_content.dart';
import 'package:dp_algebra/routing/route_state.dart';
import 'package:dp_algebra/widgets/dialog_provider.dart';
import 'package:dp_algebra/widgets/layout/bullet_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:get_it/get_it.dart';

class LPageView extends StatelessWidget {
  final LPage page;

  const LPageView({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (page.blocks.isEmpty) return const Text('Page is empty');
    return ListView.builder(
      itemCount: page.blocks.length,
      itemBuilder: (context, index) {
        LBlock block = page.blocks[index];

        List<LBlockContent> blockContent =
            BlockParser.parseBlock(block.content);

        List<List<Widget>> content = [];

        for (var part in blockContent) {
          if (part is LBlockParagraphContent) {
            content.addAll(_getParagraphContent(part.content, context));
          } else if (part is LBlockListContent) {
            List<List<Widget>> listContent = [];
            for (var row in part.content) {
              listContent.add(_getParagraphContent(row.content, context).first);
            }

            content.add([
              BulletList(
                items: listContent,
                enumerated: part.type == LBlockContentType.enumeratedList,
              )
            ]);
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: [
              if (block.showTypeTitle)
                Text(
                  block.getTitle(),
                  style: Theme.of(context).textTheme.headline3,
                ),
              for (var row in content) _getBlockWrap(row)
            ],
          ),
        );
      },
    );
  }

  List<List<Widget>> _getParagraphContent(
      List<LBlockSegment> paragraphContent, BuildContext context) {
    final theme = Theme.of(context);
    final routeState = RouteStateScope.of(context);
    DbService dbService = GetIt.instance.get<DbService>();
    List<List<Widget>> segments = [[]];

    for (var segment in paragraphContent) {
      if (segment.type == LBlockSegmentType.displayMath) segments.add([]);

      switch (segment.type) {
        case LBlockSegmentType.text:
          segments[segments.length - 1].addAll(segment.content.split(' ').map(
                (e) => Text('$e ', style: theme.textTheme.bodyText2),
              ));
          break;
        case LBlockSegmentType.inlineMath:
        case LBlockSegmentType.displayMath:
          segments[segments.length - 1].add(
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 8.0,
              children: Math.tex(
                segment.content,
                textScaleFactor:
                    segment.type == LBlockSegmentType.displayMath ? 1.4 : 1.1,
                mathStyle: segment.type == LBlockSegmentType.displayMath
                    ? MathStyle.display
                    : MathStyle.text,
              ).texBreak().parts,
            ),
          );
          break;
        case LBlockSegmentType.reference:
          if ((segment as LBlockRefSegment).refType ==
              LBlockReferenceType.block) {
            segments[segments.length - 1].add(
              FutureBuilder(
                future: dbService.fetchReference(segment.content),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData ||
                      snapshot.data == null) {
                    return const Text('(...)');
                  }

                  LRef ref = snapshot.data!;

                  return TextButton(
                    style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.zero),
                      minimumSize: MaterialStatePropertyAll(Size.zero),
                    ),
                    onPressed: () {
                      routeState.go(
                        '/chapter/${ref.chapterId}/${ref.articleId}/${ref.pageId}',
                      );
                    },
                    child: Text(
                      ref.blockNumber.toString(),
                      style: theme.textTheme.bodyText2?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  );
                },
              ),
            );
          }
          break;
        case LBlockSegmentType.literatureReference:
          segments[segments.length - 1].add(
            FutureBuilder(
              future: (segment as LLitRefSegment).references,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return const Text('(...)');
                }

                String citation = snapshot.data!
                    .map((e) => e.getHarvardCitation())
                    .toList()
                    .join("; ");

                return TextButton(
                  style: const ButtonStyle(
                    minimumSize: MaterialStatePropertyAll(Size.zero),
                    padding: MaterialStatePropertyAll(EdgeInsets.zero),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    DialogProvider.getDialog(
                      context,
                      'Detail citace',
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: snapshot.data!
                            .map((e) => SelectableText(e.getFullCitation()))
                            .toList(),
                      ),
                    ),
                  ),
                  child: Text(
                    '($citation)',
                    style: theme.textTheme.bodyText2?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                );
              },
            ),
          );
          break;
      }

      if (segment.type == LBlockSegmentType.displayMath) segments.add([]);
    }

    return segments;
  }

  Widget _getBlockWrap(List<Widget> elements) => Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 8.0,
        children: elements,
      );
}
