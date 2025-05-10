class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  int? selectedAnswerIndex;
  bool get isAnswered => selectedAnswerIndex != null;
  bool get isCorrect => selectedAnswerIndex == correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.selectedAnswerIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    // Parse the correct answer index based on the correct answer value
    final correctAnswer = json['correctAnswer'];
    final options = List<String>.from(json['options']);
    final correctAnswerIndex = options.indexOf(correctAnswer);

    return QuizQuestion(
      question: json['question'],
      options: options,
      // If the correctAnswerIndex is not found, default to 0
      correctAnswerIndex: correctAnswerIndex != -1 ? correctAnswerIndex : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctAnswer': options[correctAnswerIndex],
      'selectedAnswerIndex': selectedAnswerIndex,
    };
  }
}
