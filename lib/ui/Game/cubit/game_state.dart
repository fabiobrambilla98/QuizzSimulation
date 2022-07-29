part of 'game_cubit.dart';

@immutable
abstract class GameState {}

class GameInitial extends GameState {}

class QuizzFinished extends GameState {
  final Map<int, List<int>> aswersTaken;
  final List<Question> questions;
  QuizzFinished({required this.aswersTaken, required this.questions});
}
