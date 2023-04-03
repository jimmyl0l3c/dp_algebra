import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../data/db_service.dart';
import '../../models/db/learn_ref.dart';
import '../../routing/route_state.dart';
import 'in_text_button.dart';

class BlockRefButton extends StatelessWidget {
  final String refName;
  final String? placeholder;
  final String? text;

  const BlockRefButton({
    Key? key,
    required this.refName,
    this.placeholder,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
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

        return InTextButton(
          text: buttonText ?? ref.blockNumber.toString(),
          onPressed: () {
            routeState.go(
              '/chapter/${ref.chapterId}/${ref.articleId}/${ref.pageId}',
            );
          },
        );
      },
    );
  }
}
