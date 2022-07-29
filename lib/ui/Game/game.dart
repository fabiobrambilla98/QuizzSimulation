import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_app/models/question.dart';
import 'package:quizz_app/ui/Game/cubit/game_cubit.dart';
import 'package:quizz_app/ui/Game/summary.dart';
import 'package:quizz_app/ui/Game/widgets/checkbox_widget.dart';
import 'package:quizz_app/ui/Game/widgets/radio_widget.dart';

class Game extends StatelessWidget {
  List<Question> questions;
  final cubit = GameCubit();
  ScrollController scrollController = ScrollController();
  Game({Key? key, required this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: BlocBuilder(
            bloc: cubit,
            builder: (context, state) {
              if (state is GameInitial) {
                return StreamBuilder(
                    stream: cubit.qustionStream,
                    builder: (context, _) {
                      return Text(
                          "Question ${cubit.currentQuestion + 1}/${questions.length}");
                    });
              }
              return const Text("Summary");
            },
          ),
        ),
        body: SizedBox(
          height: height * 0.9,
          child: BlocBuilder(
            bloc: cubit,
            builder: (context, state) {
              if (state is GameInitial) {
                return StreamBuilder<Question>(
                  stream: cubit.qustionStream,
                  initialData: questions[0],
                  builder: (context, question) {
                    return SingleChildScrollView(
                        controller: scrollController,
                        child: Center(
                          child: SizedBox(
                              width: width * 0.9,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      Text(
                                        question.data!.question,
                                        style:
                                            TextStyle(fontSize: height * 0.035),
                                      ),
                                      SizedBox(
                                        height: height * 0.1,
                                      ),
                                      (question.data!.checkbox)
                                          ? StreamBuilder<List<int>>(
                                              stream: cubit.checkStream,
                                              initialData: const [],
                                              builder: (context, checked) {
                                                return BlocProvider<
                                                        GameCubit>.value(
                                                    value: cubit,
                                                    child: CheckboxWidget(
                                                        question:
                                                            question.data!,
                                                        checked:
                                                            (checked.data !=
                                                                    null)
                                                                ? checked.data!
                                                                : []));
                                              })
                                          : StreamBuilder<Answer?>(
                                              stream: cubit.answerStream,
                                              initialData: null,
                                              builder: (context, answer) {
                                                return BlocProvider<
                                                        GameCubit>.value(
                                                    value: cubit,
                                                    child: RadioWidget(
                                                        question:
                                                            question.data!,
                                                        answer: answer.data));
                                              }),
                                      SizedBox(height: height * 0.2),
                                      SizedBox(
                                        height: height * 0.07,
                                        width: width * 0.5,
                                        child: StreamBuilder<List<int>>(
                                            stream: cubit.selectedAnswersStream,
                                            initialData: const [],
                                            builder: (context, value) {
                                              return ElevatedButton(
                                                onPressed: (value.data!.isEmpty)
                                                    ? null
                                                    : () {
                                                        scrollController
                                                            .jumpTo(0.0);
                                                        cubit.newQuestion(
                                                            questions);
                                                      },
                                                child: const Text("Confirm"),
                                              );
                                            }),
                                      ),
                                      SizedBox(height: height * 0.05),
                                    ],
                                  ),
                                ],
                              )),
                        ));
                  },
                );
              }
              return BlocProvider<GameCubit>.value(
                value: cubit,
                child: const Summary(),
              );
            },
          ),
        ),
      ),
    );
  }
}
