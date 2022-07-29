class Question {
  String question;
  bool checkbox = false;
  List<Answer> answers;

  Question({required this.question, required this.answers}) {
    int count = 0;
    for (var item in answers) {
      if (item.correct) {
        count++;
      }
      if (count > 1) {
        checkbox = true;
        break;
      }
    }
  }
}

class Answer {
  String answer;
  bool correct;
  Answer({required this.answer, this.correct = false});
}
