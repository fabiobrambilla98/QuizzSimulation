import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quizz_app/models/question.dart';
import 'package:quizz_app/services/media_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void loadFile() async {
    MediaService();
    String? path = await MediaService().getPdfPath();
    if (path != null) {
      emit(LoadingFile());
      MediaService().getQuestions(path).then(
        (questions) {
          if (questions!.isNotEmpty) {
            emit(FileLoaded(questions: questions));
            emit(HomeInitial());
          } else {
            emit(LoadError());
            emit(HomeInitial());
          }
        },
      ).onError((error, stackTrace) {
        emit(LoadError());
        emit(HomeInitial());
      });
    }
  }
}
