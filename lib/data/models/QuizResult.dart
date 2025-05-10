class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final DateTime dateTime;
  final String category;
  final String difficulty;

  QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.dateTime,
    this.category = 'General Knowledge',
    this.difficulty = 'Medium',
  });

  double get percentage => (correctAnswers / totalQuestions) * 100;

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      dateTime: DateTime.parse(json['dateTime']),
      category: json['category'] ?? 'General Knowledge',
      difficulty: json['difficulty'] ?? 'Medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'dateTime': dateTime.toIso8601String(),
      'category': category,
      'difficulty': difficulty,
    };
  }
}