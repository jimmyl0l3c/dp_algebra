import 'package:flutter/material.dart';

final ThemeData algebraTheme = _algebraTheme();

ThemeData _algebraTheme() {
  final ThemeData base = ThemeData.dark();

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: Colors.deepPurple,
      onPrimary: Colors.white,
      secondary: Colors.orange[600],
      onSecondary: Colors.white,
      error: Colors.redAccent,
    ),
    // appBarTheme: base.appBarTheme.copyWith(
    //   backgroundColor: Colors.blue,
    // ),
    textTheme: _algebraTextTheme(base.textTheme),
    elevatedButtonTheme: _algebraElevatedButtonTheme(),
    outlinedButtonTheme: _algebraOutlinedButtonTheme(),
    toggleButtonsTheme: _algebraToggleButtonTheme(),
    inputDecorationTheme: _algebraInputTheme(),
    snackBarTheme: _algebraSnackbarTheme(),
  );
}

TextTheme _algebraTextTheme(TextTheme base) => base.copyWith(
// for our appbars title
      headline1: base.headline1!.copyWith(),
// for widgets heading/title
      headline2: base.headline2!.copyWith(),
// for sub-widgets heading/title - learn title
      headline3: base.headline3!.copyWith(
        fontSize: 24,
        color: Colors.white,
      ),
// calc headlines
      headline4: base.headline4!.copyWith(
        color: Colors.white,
        letterSpacing: .8,
        fontSize: 24,
      ),
// calc lower headlines
      headline5: base.headline4!.copyWith(
        color: Colors.white,
        letterSpacing: .8,
        fontSize: 18,
      ),
// for widgets contents/paragraph
      bodyText1: base.bodyText1!.copyWith(),
// for sub-widgets contents/paragraph - learn paragraph
      bodyText2: base.bodyText2!.copyWith(),
    );

ElevatedButtonThemeData _algebraElevatedButtonTheme() =>
    const ElevatedButtonThemeData(style: ButtonStyle());

OutlinedButtonThemeData _algebraOutlinedButtonTheme() =>
    OutlinedButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return Colors.yellow.withOpacity(.15);
        }
        if (states.contains(MaterialState.focused) ||
            states.contains(MaterialState.hovered)) {
          return Colors.orangeAccent.withOpacity(.1);
        }
        return Colors.transparent;
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        return Colors.orange;
      }),
      side: MaterialStateProperty.resolveWith((states) {
        return const BorderSide(color: Colors.orange);
      }),
    ));

ToggleButtonsThemeData _algebraToggleButtonTheme() =>
    const ToggleButtonsThemeData();

InputDecorationTheme _algebraInputTheme() => const InputDecorationTheme(
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.yellow),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      hintStyle: TextStyle(),
    );

SnackBarThemeData _algebraSnackbarTheme() => const SnackBarThemeData(
      backgroundColor: Colors.white24,
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
      actionTextColor: Colors.deepPurple,
    );
