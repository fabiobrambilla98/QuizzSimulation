import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quizz_app/models/question.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameInitial());
  final Map<int, List<int>> _answersTaken = {};
  final List<int> selectedAnswers = [];
  int currentQuestion = 0;

  final StreamController<Question> _questionController =
      StreamController.broadcast();
  final StreamController<Answer?> _answerController =
      StreamController.broadcast();
  final StreamController<List<int>> _checkedAnserController =
      StreamController.broadcast();
  final StreamController<List<int>> _selectedAnswersController =
      StreamController.broadcast();

  Stream<Question> get qustionStream => _questionController.stream;
  Stream<Answer?> get answerStream => _answerController.stream;
  Stream<List<int>> get checkStream => _checkedAnserController.stream;
  Stream<List<int>> get selectedAnswersStream =>
      _selectedAnswersController.stream;

  void selectAnswer(Answer answer, int pos) {
    selectedAnswers.clear();
    selectedAnswers.add(pos);
    _answerController.add(answer);
    _selectedAnswersController.add(selectedAnswers);
  }

  void tapAnswer(int position) {
    if (selectedAnswers.contains(position)) {
      selectedAnswers.remove(position);
      _checkedAnserController.add(selectedAnswers);
    } else {
      selectedAnswers.add(position);
      _checkedAnserController.add(selectedAnswers);
    }
    _selectedAnswersController.add(selectedAnswers);
  }

  void newQuestion(List<Question> questions) {
    _answersTaken[currentQuestion] = List<int>.from(selectedAnswers);
    selectedAnswers.clear();

    if (currentQuestion + 1 < questions.length) {
      currentQuestion++;
      _questionController.add(questions[currentQuestion]);
      _answerController.add(null);
    } else {
      emit(QuizzFinished(aswersTaken: _answersTaken, questions: questions));
    }
  }
}
