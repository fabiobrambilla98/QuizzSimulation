import 'package:file_picker/file_picker.dart';
import 'package:quizz_app/models/question.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:quizz_app/utils/characters.dart';
import 'package:quizz_app/utils/extensions.dart';

class MediaService {
  static final MediaService _singleton = MediaService._internal();

  factory MediaService() {
    return _singleton;
  }

  MediaService._internal();

  Future<String?> getPdfPath() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    return result?.files.single.path;
  }

  Future<List<Question>?> getQuestions(String path) async {
    PDFDoc doc = await PDFDoc.fromPath(path);
    String text = await doc.text;
    return _splitQuestions(text);
  }

  List<Question> _splitQuestions(String text) {
    var txt = text.replaceAll("\n", "SPACE");
    var questions = txt.split(Character.question.symbol);
    questions.removeAt(0);
    List<Question> questionList = [];
    for (var element in questions) {
      var lines = element.split("SPACE");
      var question = lines[0];
      List<Answer> answers = [];
      for (var el in lines.sublist(1)) {
        var elReplace = el.replaceAll(" ", "");
        if (elReplace.isNotEmpty) {
          if (elReplace[0] == Character.wrongAnswer.symbol) {
            answers.add(Answer(answer: el.removeFirstSpaces.substring(1)));
          } else if (elReplace[0] == Character.correctAnswer.symbol) {
            answers.add(Answer(
                answer: el.removeFirstSpaces.substring(1), correct: true));
          }
        }
      }
      questionList.add(Question(question: question, answers: answers));
    }

    return questionList;
  }
}
