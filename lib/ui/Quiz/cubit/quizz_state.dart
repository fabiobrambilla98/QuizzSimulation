part of 'quizz_cubit.dart';

@immutable
abstract class QuizzState {}

class QuizzInitial extends QuizzState {}

class Start extends QuizzState {
  List<Question> questions;
  Start({required this.questions});
}
