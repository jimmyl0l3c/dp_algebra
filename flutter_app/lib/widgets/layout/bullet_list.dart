import 'package:flutter/material.dart';

class BulletList extends StatelessWidget {
  final List<List<Widget>> items;
  final bool enumerated;

  const BulletList({
    super.key,
    required this.items,
    this.enumerated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 8.0,
              children: [
                enumerated
                    ? SizedBox(
                        width: 20,
                        child: Text('${i + 1}.'),
                      )
                    : const Text('\u2022'),
                const SizedBox(width: 10),
                for (var segment in items[i]) segment,
              ],
            ),
          )
      ],
    );
  }
}
