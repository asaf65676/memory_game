import 'package:flutter/material.dart';
import 'package:memory_game/__memory_game_page_state.dart';
import 'package:memory_game/main.dart';


class MemoryGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'משחק הזיכרון', // הגדרת הכותרת
      home: MemoryGamePage(), // הגדרת העמוד הראשי של האפליקציה שהוא עמוד המשחק
    );
  }
}
