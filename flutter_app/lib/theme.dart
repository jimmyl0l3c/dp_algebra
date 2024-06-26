import 'package:flutter/material.dart';

final ThemeData algebraTheme = _algebraTheme();

ThemeData _algebraTheme() {
  final ThemeData base = ThemeData.dark(useMaterial3: false);

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
    tooltipTheme: const TooltipThemeData(
      textStyle: TextStyle(
        color: Colors.black,
        fontSize: 14.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: Colors.white70, // or white70
      ),
    ),
  );
}

TextTheme _algebraTextTheme(TextTheme base) => base.copyWith(
// for our appbars title
      displayLarge: base.displayLarge!.copyWith(),
// for widgets heading/title
      displayMedium: base.displayMedium!.copyWith(),
// for sub-widgets heading/title - learn title
      displaySmall: base.displaySmall!.copyWith(
        fontSize: 24,
        color: Colors.white,
      ),
// calc headlines
      headlineMedium: base.headlineMedium!.copyWith(
        color: Colors.white,
        letterSpacing: .8,
        fontSize: 24,
      ),
// calc lower headlines
      headlineSmall: base.headlineMedium!.copyWith(
        color: Colors.white,
        letterSpacing: .8,
        fontSize: 18,
      ),
// for widgets contents/paragraph
      bodyLarge: base.bodyLarge!.copyWith(),
// for sub-widgets contents/paragraph - learn paragraph
      bodyMedium: base.bodyMedium!.copyWith(),
    );

ElevatedButtonThemeData _algebraElevatedButtonTheme() =>
    const ElevatedButtonThemeData(style: ButtonStyle());

OutlinedButtonThemeData _algebraOutlinedButtonTheme() =>
    OutlinedButtonThemeData(
        style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.yellow.withOpacity(.15);
        }
        if (states.contains(WidgetState.focused) ||
            states.contains(WidgetState.hovered)) {
          return Colors.orangeAccent.withOpacity(.1);
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        return Colors.orange;
      }),
      side: WidgetStateProperty.resolveWith((states) {
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
