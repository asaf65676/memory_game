import 'package:flutter/material.dart';
import 'package:memory_game/main.dart';

import 'all_the_card.dart';

class CardWidget extends StatelessWidget {
  final AllTheCard card; // מודל הקלף
  final Function() onPressed; // פעולה לביצוע בלחיצה על הקלף

  CardWidget({required this.card, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // פעולה לביצוע בלחיצה על הקלף
      child: Container(
        decoration: BoxDecoration(
          color: card.isFlipped
              ? Colors.white
              : Color.fromARGB(255, 170, 176, 181), // צבע הקלף תלוי אם הוא הפוך או לא
        ),
        child: Center(
          child: Text(
            card.isFlipped
                ? card.word
                : '?', // הצגת המילה או סימן השאלה תלוי אם הקלף הפוך
            style: TextStyle(
              fontSize: 40.0, // גודל הגופן של הטקסט
            ),
          ),
        ),
      ),
    );
  }
}
