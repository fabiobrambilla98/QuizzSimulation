import 'package:flutter/material.dart';
import 'package:quizz_app/ui/Home/home_page.dart';

void main() {
  runApp(const QuizzApp());
}

class QuizzApp extends StatelessWidget {
  const QuizzApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Quizz App",
      home: HomePage(),
    );
  }
}
