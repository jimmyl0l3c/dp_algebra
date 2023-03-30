import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:get_it/get_it.dart';

import '../data/block_parser.dart';
import '../data/db_service.dart';
import '../models/db/learn_block.dart';
import '../models/db/learn_page.dart';
import '../models/db/learn_ref.dart';
import '../models/learn/block_content.dart';
import '../routing/route_state.dart';
import '../utils/get_dialog_route.dart';
import 'layout/bullet_list.dart';

class LPageView extends StatelessWidget {
  final LPage page;

  const LPageView({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (page.blocks.isEmpty) return const Text('Page is empty');
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
      itemCount: page.blocks.length,
      itemBuilder: (context, index) {
        LBlock block = page.blocks[index];

        if (block.typeTitle == 'image') {
          return Column(
            children: [
              FittedBox(
                fit: BoxFit.contain,
                // TODO: have dynamic constrains based on screen size
                child: CachedNetworkImage(
                  errorWidget: (context, url, error) => Column(
                    children: const [
                      Icon(Icons.error),
                      Text("Error occurred when loading an image"),
                    ],
                  ),
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  imageUrl:
                      'http${DbService.devEnv ? "" : "s"}://${DbService.apiUrl}/api/learn/image?ref_name=${block.content}',
                ),
              ),
              if (block.title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0, top: 12.0),
                  child: Text(
                    "Obrázek: ${block.title}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
            ],
          );
        }

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
          // Padding of blocks
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: [
              if (block.showTypeTitle)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0, top: 12.0),
                  child: Text(
                    block.fullTitle,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              for (var row in content)
                Padding(
                  // Padding of paragraphs of a block
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _getBlockWrap(row),
                ),
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
      if (segment.content.trim().isEmpty) continue;
      if (segment.type == LBlockSegmentType.displayMath) segments.add([]);

      switch (segment.type) {
        case LBlockSegmentType.text:
          segments[segments.length - 1].addAll(segment.content.split(' ').map(
                (e) => Text('$e ', style: theme.textTheme.bodyMedium),
              ));
          break;
        case LBlockSegmentType.inlineMath:
          segments[segments.length - 1].add(
            Math.tex(
              segment.content,
              textScaleFactor: 1.2,
              mathStyle: MathStyle.text,
              textStyle: theme.textTheme.bodyMedium,
            ),
          );
          break;
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
                textScaleFactor: 1.4,
                mathStyle: MathStyle.display,
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
                      style: theme.textTheme.bodyMedium?.copyWith(
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
                    .map((e) => e.harvardCitation)
                    .toList()
                    .join("; ");

                return TextButton(
                  style: const ButtonStyle(
                    minimumSize: MaterialStatePropertyAll(Size.zero),
                    padding: MaterialStatePropertyAll(EdgeInsets.zero),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    getDialogRoute(
                      context,
                      'Detail citace',
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: snapshot.data!
                            .map((e) => SelectableText(e.fullCitation))
                            .toList(),
                      ),
                    ),
                  ),
                  child: Text(
                    '($citation)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                );
              },
            ),
          );
          break;
        case LBlockSegmentType.tabular:
          if (segment is! LBlockTabularCellSegment || segment.cells.isEmpty) {
            continue;
          }
          segments[segments.length - 1].add(
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 50 * segment.width.toDouble(),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _getParagraphContent(segment.cells, context).first,
              ),
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
