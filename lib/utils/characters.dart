enum Character { question, wrongAnswer, correctAnswer, image }

extension ExtensionCharacter on Character {
  String get symbol {
    switch (this) {
      case Character.question:
        return '§';
      case Character.wrongAnswer:
        return '-';
      case Character.correctAnswer:
        return '+';
      case Character.image:
        return '°';
    }
  }
}
