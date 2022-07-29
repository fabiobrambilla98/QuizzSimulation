import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_app/models/question.dart';
import 'package:quizz_app/ui/Game/cubit/game_cubit.dart';
import 'package:quizz_app/ui/Quiz/cubit/quizz_cubit.dart';

class RadioWidget extends StatelessWidget {
  final Question question;
  final Answer? answer;

  const RadioWidget({Key? key, required this.question, required this.answer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final cubit = context.read<GameCubit>();
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: height * 0.01,
          );
        },
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: question.answers.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                if (cubit.state is GameInitial) {
                  for (var a in question.answers) {
                    if (question.answers[index].answer == a.answer) {
                      cubit.selectAnswer(a, index);
                      break;
                    }
                  }
                }
              },
              child: (cubit.state is GameInitial)
                  ? Card(
                      elevation: 2,
                      color: (question.answers[index].answer == answer?.answer)
                          ? Colors.blueGrey[50]
                          : Colors.white,
                      child: ListTile(
                        leading: Radio(
                            value: question.answers[index].answer,
                            groupValue: answer?.answer,
                            onChanged: (String? newValue) {
                              for (var a in question.answers) {
                                if (newValue == a.answer) {
                                  cubit.selectAnswer(a, index);
                                  break;
                                }
                              }
                            }),
                        title: Text(
                          question.answers[index].answer,
                          style: TextStyle(fontSize: height * 0.025),
                        ),
                      ))
                  : Card(
                      elevation: 2,
                      color: (question.answers[index].correct &&
                              (cubit.state as QuizzFinished)
                                  .aswersTaken[(cubit.state as QuizzFinished)
                                      .questions
                                      .indexOf(question)]!
                                  .contains(index))
                          ? Colors.green[300]
                          : (question.answers[index].correct)
                              ? Colors.green[300]
                              : ((cubit.state as QuizzFinished)
                                      .aswersTaken[
                                          (cubit.state as QuizzFinished)
                                              .questions
                                              .indexOf(question)]!
                                      .contains(index))
                                  ? Colors.red[300]
                                  : Colors.white,
                      child: ListTile(
                        leading: Radio(
                            value: question.answers[index].answer,
                            groupValue: answer?.answer,
                            onChanged: (String? newValue) {}),
                        title: Text(
                          question.answers[index].answer,
                          style: TextStyle(fontSize: height * 0.025),
                        ),
                      )));
        });
  }
}
