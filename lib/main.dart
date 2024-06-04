import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Center(child: GameRwo(4))));
  }
}

class GameColumn extends StatelessWidget {
  final int columnNumber;
  const GameColumn(this.columnNumber);

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [];
    for (int i = 0; i < columnNumber; i++) {
      final button = Container(
        padding: EdgeInsets.all(10),
        color: Color.fromARGB(255, 33, 243, 37),
        child: ElevatedButton(
          onPressed: () => {},
          child: Text('Press me $i'),
        ),
      );
      buttons.add(button);
    }

    return Column(children: buttons);
  }
}

class GameRwo extends StatelessWidget {
  final int rowsNumber;
  const GameRwo(this.rowsNumber);

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];

    for (int i = 0; i < rowsNumber; i++) {
      // rows.add(buildColumn(4));
      rows.add(GameColumn(4));
    }

    return Row(children: rows);
  }
}
