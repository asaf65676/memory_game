import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// הפונקציה הראשית של האפליקציה
void main() {
  runApp(MemoryGame());
}

// ויידג'ט ראשי של האפליקציה
class MemoryGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'משחק הזיכרון', // הגדרת הכותרת
      home: MemoryGamePage(), // הגדרת העמוד הראשי של האפליקציה שהוא עמוד המשחק
    );
  }
}

// ויידג'ט Stateful של הדף הראשי של המשחק
class MemoryGamePage extends StatefulWidget {
  @override
  _MemoryGamePageState createState() => _MemoryGamePageState();
}

// מצב הדף הראשי של המשחק
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
                'Score: $score', // Display the current score
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height:20), // Add some space between the Text widget and the ElevatedButton
              ElevatedButton(
                onPressed: buttonResetGame,
                child: Text('Game Reset'),
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

// ויידג'ט של קלף בודד
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

// מודל של קלף
class AllTheCard {
  final String word; // המילה שעל הקלף
  bool isFlipped; // דגל האם הקלף הפוך

  AllTheCard({required this.word, required this.isFlipped});

  // פעולה להפיכת הקלף
  void flip() {
    isFlipped = !isFlipped; // החלפת מצב הפתיחה של הקלף
  }
}
