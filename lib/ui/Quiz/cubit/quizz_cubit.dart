import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quizz_app/models/question.dart';

part 'quizz_state.dart';

class QuizzCubit extends Cubit<QuizzState> {
  QuizzCubit() : super(QuizzInitial());

  void startQuizz(List<Question> questions) {
    emit(Start(questions: questions));
  }
}
