class Question {
  Question(this.question, this.answer);

  String question;
  bool answer;

  bool isCorrect(bool userAnswer) {
    return userAnswer == answer;
  }
}
