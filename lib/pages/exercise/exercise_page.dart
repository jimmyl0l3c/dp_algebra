import 'package:dp_algebra/widgets/button_row.dart';
import 'package:flutter/material.dart';

class ExercisePage extends StatelessWidget {
  final List<ButtonRowItem> generateButtons;
  final Widget example;
  final Widget result;
  final List<ButtonRowItem> resolveButtons;

  const ExercisePage({
    Key? key,
    required this.generateButtons,
    required this.example,
    required this.result,
    required this.resolveButtons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
        vertical: 12.0,
      ),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                runSpacing: 8.0,
                children: [
                  const Text('Vygenerovat: '),
                  ButtonRow(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    children: generateButtons,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: example,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: result,
            ),
            ButtonRow(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              children: resolveButtons,
            ),
          ],
        ),
      ),
    );
  }
}
