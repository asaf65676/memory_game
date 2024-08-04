import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memory_game/main.dart';
import 'all_the_card.dart';
import 'card_widget.dart';

class MemoryGamePage extends StatefulWidget {
  @override
  _MemoryGamePageState createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  late List<AllTheCard> cards; // רשימת כל הקלפים במשחק
  late List<AllTheCard> openCards; // רשימת הקלפים שפתוחים עכשיו
  late int score; // מונה הניקוד של השחקן
  late Timer? timer; // טיימר לסגירת קלפים אם לא נמצאה התאמה

  @override
  void initState() {
    super.initState();
    gameReset(); // אתחול המשחק בתחילת הפעלת הדף
  }

  // פונקציה לאיפוס המשחק
  void buttonResetGame() {
    setState(() {
      gameReset(); // אתחול המשחק מחדש
    });
  }

  // אתחול המשחק: איפוס כל המשתנים
  void gameReset() {
    cards = generateCards(); // יצירת רשימת קלפים
    cards.shuffle(); // ערבוב הקלפים
    openCards = []; // איפוס רשימת הקלפים שנפתחו
    score = 0; // איפוס מונה הניקוד
  }

  // יצירת רשימת הקלפים
  List<AllTheCard> generateCards() {
    // רשימת מילים שתשמש בתור הערכים שעל הקלפים
    List<String> words = ['סגול','צהוב','חום','לבן','אפור','שחור','ירוק','אדום',];

    List<AllTheCard> generatedCards = []; // פתיחת מערך ריק

    for (String word in words) {
      generatedCards.add(AllTheCard(word: word, isFlipped: false)); // יצירת זוג קלפים עבור כל מילה
      generatedCards.add(AllTheCard(word: word, isFlipped: false));
    }
    return generatedCards; // החזרת רשימת הקלפים
  }

  // פונקציה שמטפלת בלחיצה על קלף
  void onCardPressed(int index) {
    // בדיקה אם אפשר לפתוח קלף נוסף
    if (openCards.length < 2 && !openCards.contains(cards[index])) {
      setState(() {
        cards[index].flip(); // הפיכת הקלף
        openCards.add(cards[index]); // הוספת הקלף לרשימת הקלפים שנפתחו
      });

      // אם נפתחו שני קלפים
      if (openCards.length == 2) {
        if (openCards[0].word != openCards[1].word) {
          // אם אין התאמה בין הקלפים
          timer = Timer(Duration(seconds: 1), () {
            setState(() {
              openCards[0].flip(); // סגירת הקלף הראשון
              openCards[1].flip(); // סגירת הקלף השני
              openCards = []; // איפוס רשימת הקלפים שנפתחו
            });
          });
        } else {
          // אם יש התאמה בין הקלפים
          openCards = []; // איפוס רשימת הקלפים שנפתחו
          setState(() {
            score++; // עדכון מונה הניקוד
          });
        }
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel(); // ביטול הטיימר אם קיים
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('משחק הזיכרון'), // כותרת האפליקציה
          centerTitle: true, // מרכוז הכותרת
      ),
      
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'ניקוד: $score', 
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height:20), 
              ElevatedButton(
                onPressed: buttonResetGame,
                child: Text('משחק חדש'),
              ),
            ],
          ),

          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // מספר העמודות ברשת
                mainAxisSpacing: 10.0, // רווח אנכי בין הקלפים
                crossAxisSpacing: 10.0, // רווח אופקי בין הקלפים
                childAspectRatio: 3.0, // יחס גובה-רוחב של הקלפים
              ),
              itemCount: cards.length, // מספר הקלפים ברשת
              itemBuilder: (context, index) {
                return CardWidget(
                  card: cards[index], // הקלף הנוכחי
                  onPressed: () {
                    onCardPressed(index); // פעולה לביצוע בלחיצה על הקלף
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
