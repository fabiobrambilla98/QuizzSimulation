import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_app/models/question.dart';
import 'package:quizz_app/ui/Game/game.dart';
import 'package:quizz_app/ui/Quiz/cubit/quizz_cubit.dart';
import 'package:quizz_app/utils/extensions.dart';

class QuizzPage extends StatefulWidget {
  final List<Question> questions;
  final cubit = QuizzCubit();
  final numberController = TextEditingController();
  bool maxPressed = false;
  QuizzPage({Key? key, required this.questions}) : super(key: key);

  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (int.parse(widget.numberController.text) > widget.questions.length) {
          widget.numberController.text = widget.questions.length.toString();
        }
      },
      child: Scaffold(
          appBar: AppBar(title: const Text("Select number")),
          body: BlocListener(
            bloc: widget.cubit,
            listener: (context, state) {
              if (state is Start) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Game(
                          questions: state.questions.sublist(
                              0, int.parse(widget.numberController.text)))),
                );
              }
            },
            child: SingleChildScrollView(
              child: SizedBox(
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
                              controller: widget.numberController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
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
                                    setState(() {
                                      widget.numberController.value =
                                          TextEditingValue(
                                              text: widget.questions.length
                                                  .toString());
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    });
                                  },
                                  child: const Text("Max"))
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
                              onPressed: (widget
                                          .numberController.text.isEmpty ||
                                      int.parse(widget.numberController.text) <
                                          1)
                                  ? null
                                  : () {
                                      widget.cubit.startQuizz(
                                          widget.questions.shuffleAll);
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
