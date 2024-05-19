import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../data/db_service.dart';
import '../../models/db/learn_ref.dart';
import 'in_text_button.dart';

class BlockRefButton extends StatelessWidget {
  final String refName;
  final String? placeholder;
  final String? text;
  final String? tooltip;

  const BlockRefButton({
    Key? key,
    required this.refName,
    this.placeholder,
    this.text,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DbService dbService = GetIt.instance.get<DbService>();

    return FutureBuilder(
      future: dbService.fetchReference(refName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData ||
            snapshot.data == null) {
          return Text(placeholder ?? '(...)');
        }

        LRef ref = snapshot.data!;

        var buttonText = text?.replaceAll(
          r'$number',
          ref.blockNumber.toString(),
        );

        var button = InTextButton(
          text: buttonText ?? ref.blockNumber.toString(),
          onPressed: () {
            context.go(
              '/chapter/${ref.chapterId}/${ref.articleId}/${ref.pageId}',
            );
          },
        );

        if (tooltip != null) {
          return Tooltip(message: tooltip, child: button);
        } else {
          return button;
        }
      },
    );
  }
}
