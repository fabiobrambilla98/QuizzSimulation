import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_app/ui/Game/cubit/game_cubit.dart';
import 'package:quizz_app/ui/Game/widgets/checkbox_widget.dart';
import 'package:quizz_app/ui/Game/widgets/radio_widget.dart';

class Summary extends StatelessWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GameCubit>();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder(
        bloc: cubit,
        buildWhen: (p, s) {
          if (s == QuizzFinished) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is QuizzFinished) {
            return SingleChildScrollView(
                child: Column(children: [
              ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: height * 0.08,
                    );
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.questions.length,
                  itemBuilder: (context, index) {
                    return Card(
                        elevation: 0,
                        color: Colors.grey[200],
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(height * 0.02),
                              child: Text(
                                state.questions[index].question,
                                style: TextStyle(fontSize: height * 0.035),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            (state.questions[index].checkbox)
                                ? CheckboxWidget(
                                    question: state.questions[index],
                                    checked: state.aswersTaken[index]!)
                                : RadioWidget(
                                    question: state.questions[index],
                                    answer: state.questions[index].answers[
                                        state.aswersTaken[index]!.first],
                                  ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                          ],
                        ));
                  }),
              SizedBox(
                height: height * 0.2,
              ),
              SizedBox(
                height: height * 0.07,
                width: width * 0.5,
                child: ElevatedButton(
                  child: const Text("Return"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: height * 0.05),
            ]));
          }
          return Container();
        });
  }
}
