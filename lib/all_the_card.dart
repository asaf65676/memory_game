class AllTheCard {
  final String word; // המילה שעל הקלף
  bool isFlipped; // דגל האם הקלף הפוך

  AllTheCard({required this.word, required this.isFlipped});

  // פעולה להפיכת הקלף
  void flip() {
    isFlipped = !isFlipped; // החלפת מצב הפתיחה של הקלף
  }
}
