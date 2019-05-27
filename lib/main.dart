import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'quiz_brain.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuizBrain brain = QuizBrain();
  List<Icon> scoreKeeper = [];

  void correctAnswer() {
    scoreKeeper.add(
      Icon(
        Icons.check,
        color: Colors.green,
      ),
    );
  }

  void wrongAnswer() {
    scoreKeeper.add(
      Icon(
        Icons.close,
        color: Colors.red,
      ),
    );
  }

  VoidCallback answer(bool userAnswer) {
    return () {
      setState(() {
        if (brain.isCorrect(userAnswer)) {
          correctAnswer();
        } else {
          wrongAnswer();
        }

        brain.nextQuestion(finishQuiz);
      });
    };
  }

  void finishQuiz() {
    int correct = scoreKeeper.where((Icon icon) {
      return icon.color == Colors.green;
    }).length;
    int wrong = scoreKeeper.length - correct;

    Alert(
        context: context,
        title: 'Congratulations',
        style: AlertStyle(
          animationType: AnimationType.grow,
          isCloseButton: false,
          isOverlayTapDismiss: false,
        ),
        content: Column(
          children: <Widget>[
            Text('You\'ve got $correct answers correct'),
            Text('and'),
            Text('$wrong answers wrong!')
          ],
        ),
        buttons: [
          DialogButton(
            child: Text('Ok'),
            onPressed: () {
              setState(() {
                brain.firstQuestion();
                scoreKeeper = <Icon>[];

                Navigator.pop(context);
              });
            },
          )
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                brain.currentQuestion.question,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: answer(true),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: answer(false),
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
