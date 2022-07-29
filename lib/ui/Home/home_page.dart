import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quizz_app/services/media_service.dart';
import 'package:quizz_app/ui/Home/cubit/home_cubit.dart';
import 'package:quizz_app/ui/Quiz/quiz_page.dart';

class HomePage extends StatelessWidget {
  final cubit = HomeCubit();
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: BlocListener(
        bloc: cubit,
        listener: (context, state) {
          if (state is FileLoaded) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuizzPage(questions: state.questions)),
            );
          }
          if (state is LoadError) {
            Fluttertoast.showToast(
                msg: "Something went wrong",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16);
          }
        },
        child: BlocBuilder(
          bloc: cubit,
          buildWhen: (p, s) {
            if (p is LoadingFile && s is HomeInitial) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: width * 0.4,
                  height: height * 0.06,
                  child: ElevatedButton(
                      onPressed: (state is LoadingFile)
                          ? null
                          : () {
                              cubit.loadFile();
                            },
                      child: (state is LoadingFile)
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text("Open")),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
