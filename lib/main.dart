import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MemoryGame());
}

class MemoryGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemoryGamePage(),
    );
  }
}

class MemoryGamePage extends StatefulWidget {
  @override
  _MemoryGamePageState createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  late List<CardModel> cards;
  late List<CardModel> flippedCards;
  late bool isFlipping;
  late int attempts;
  late int score;
  late Timer? timer;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    cards = generateCards();
    cards.shuffle();
    flippedCards = [];
    isFlipping = false;
    attempts = 0;
    score = 0;
  }

  List<CardModel> generateCards() {
    List<String> words = [
      'Apple',
      'Banana',
      'Cherry',
      'Grape',
      'Lemon',
      'Orange',
      'Peach',
      'Strawberry',
    ];
    List<CardModel> generatedCards = [];
    for (String word in words) {
      generatedCards.add(CardModel(word: word, isFlipped: false));
      generatedCards.add(CardModel(word: word, isFlipped: false));
    }
    return generatedCards;
  }

  void onCardPressed(int index) {
    if (!isFlipping && !flippedCards.contains(cards[index])) {
      setState(() {
        cards[index].flip();
        flippedCards.add(cards[index]);
      });
      if (flippedCards.length == 2) {
        isFlipping = true;
        attempts++;
        if (flippedCards[0].word != flippedCards[1].word) {
          timer = Timer(Duration(seconds: 1), () {
            setState(() {
              flippedCards[0].flip();
              flippedCards[1].flip();
              flippedCards = [];
              isFlipping = false;
            });
          });
        } else {
          flippedCards = [];
          isFlipping = false;
          setState(() {
            score++;
          });
        }
      }
    }
  }

  void resetGame() {
    setState(() {
      initializeGame();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Score: $score',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: resetGame,
                child: Text('Reset Game'),
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 3.0,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return CardWidget(
                  card: cards[index],
                  onPressed: () {
                    onCardPressed(index);
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

class CardWidget extends StatelessWidget {
  final CardModel card;
  final Function() onPressed;

  CardWidget({required this.card, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: card.isFlipped ? Colors.white : Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            card.isFlipped ? card.word : '?',
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              color: card.isFlipped ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CardModel {
  final String word;
  bool isFlipped;

  CardModel({required this.word, required this.isFlipped});

  void flip() {
    isFlipped = !isFlipped;
  }
}
