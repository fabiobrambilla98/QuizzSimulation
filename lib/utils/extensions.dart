import 'package:quizz_app/models/question.dart';
import 'package:quizz_app/utils/characters.dart';

extension StringExtension on String {
  String get removeFirstSpaces {
    int count = 0;
    for (int i = 0; i < length; i++) {
      if (this[i] != " ") {
        break;
      } else {
        count++;
      }
    }
    return this..substring(count);
  }
}

extension ListQuestionExtension on List<Question> {
  List<Question> get shuffleAll {
    List<Question> newList = List<Question>.from(this);
    newList.shuffle();
    for (var item in newList) {
      item.answers.shuffle();
    }
    return newList;
  }
}

extension ListAnswerExtension on List<Answer> {}
