import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import 'router.dart';
import 'theme.dart';

class AlgebraApp extends StatefulWidget {
  const AlgebraApp({super.key});

  @override
  State<AlgebraApp> createState() => _AlgebraAppState();
}

class _AlgebraAppState extends State<AlgebraApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Lineární Algebra',
        routerConfig: GetIt.instance.get<AlgebraRouter>().router,
        theme: algebraTheme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('cs'),
        ],
      );

  @override
  void dispose() {
    super.dispose();
  }
}
