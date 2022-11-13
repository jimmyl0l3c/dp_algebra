import 'package:flutter/material.dart';

class CalcVectorIndependence extends StatelessWidget {
  const CalcVectorIndependence({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          Divider(),
          Text('Operace'),
          OutlinedButton(
            onPressed: null,
            child: Text('Lineární nezávislost'),
          ),
          Divider(),
          Text('Výsledky:'),
        ],
      ),
    );
  }
}
