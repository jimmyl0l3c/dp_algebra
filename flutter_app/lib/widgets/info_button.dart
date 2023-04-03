import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../data/db_service.dart';
import '../models/db/learn_ref.dart';
import '../routing/route_state.dart';

class InfoButton extends StatelessWidget {
  final String refName;
  final String? tooltip;

  const InfoButton({Key? key, required this.refName, this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    DbService dbService = GetIt.instance.get<DbService>();

    return FutureBuilder(
      future: dbService.fetchReference(refName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Icon(
            Icons.info,
            size: 18.0,
            color: Colors.grey,
          );
        }

        LRef ref = snapshot.data!;

        return IconButton(
          onPressed: () {
            routeState.go(
              '/chapter/${ref.chapterId}/${ref.articleId}/${ref.pageId}',
            );
          },
          icon: const Icon(
            Icons.info,
            size: 18,
          ),
          splashRadius: 12.0,
          constraints: const BoxConstraints(maxWidth: 20),
          padding: EdgeInsets.zero,
          color: Colors.deepPurpleAccent,
          tooltip: tooltip ?? "Zjistit více",
        );
      },
    );
  }
}
