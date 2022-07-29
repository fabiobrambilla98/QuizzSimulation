import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_app/models/question.dart';
import 'package:quizz_app/ui/Game/game.dart';
import 'package:quizz_app/ui/Quiz/cubit/quizz_cubit.dart';
import 'package:quizz_app/utils/extensions.dart';

class QuizzPage extends StatelessWidget {
  final List<Question> questions;
  final cubit = QuizzCubit();
  final numberController = TextEditingController();
  bool maxPressed = false;
  QuizzPage({Key? key, required this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (int.parse(numberController.text) > questions.length) {
          numberController.text = questions.length.toString();
        }
      },
      child: Scaffold(
          appBar: AppBar(title: Text("Select number")),
          body: BlocListener(
            bloc: cubit,
            listener: (context, state) {
              if (state is Start) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Game(
                          questions: state.questions
                              .sublist(0, int.parse(numberController.text)))),
                );
              }
            },
            child: SingleChildScrollView(
              child: Container(
                height: height * 0.8,
                width: width,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Number of questions",
                            style: TextStyle(fontSize: height * 0.025),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          SizedBox(
                            width: width * 0.25,
                            height: height * 0.07,
                            child: TextField(
                              onChanged: (String value) {},
                              controller: numberController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: '0',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    numberController.text =
                                        questions.length.toString();
                                  },
                                  child: Text("Max"))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        child: SizedBox(
                          width: width * 0.6,
                          height: height * 0.07,
                          child: ElevatedButton(
                              onPressed: (numberController.text.isEmpty ||
                                      int.parse(numberController.text) < 1)
                                  ? null
                                  : () {
                                      cubit.startQuizz(questions.shuffleAll);
                                    },
                              child: Text(
                                "Start",
                                style: TextStyle(fontSize: height * 0.025),
                              )),
                        ))
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
