part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class FileLoaded extends HomeState {
  final List<Question> questions;
  FileLoaded({required this.questions});
}

class LoadingFile extends HomeState {}

class LoadError extends HomeState {}
