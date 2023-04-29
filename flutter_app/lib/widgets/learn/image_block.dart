import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/db_service.dart';
import '../../models/db/learn_block.dart';

class ImageBlock extends StatelessWidget {
  final LBlock block;

  const ImageBlock({Key? key, required this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imgNum = block.number != null ? ' ${block.number}' : '';

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.contain,
          // TODO: have dynamic constrains based on screen size
          child: CachedNetworkImage(
            errorWidget: (context, url, error) => Column(
              children: const [
                Icon(Icons.error),
                Text('Error occurred when loading an image'),
              ],
            ),
            fit: BoxFit.contain,
            placeholder: (context, url) => const CircularProgressIndicator(),
            imageUrl:
                'http${DbService.devEnv ? "" : "s"}://${DbService.apiUrl}/api/learn/image/${block.content}',
          ),
        ),
        if (block.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0, top: 12.0),
            child: Text(
              '${block.typeTitle}$imgNum: ${block.title}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
      ],
    );
  }
}
