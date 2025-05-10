import 'dart:async';
import 'package:get/get.dart';
import 'package:quiz_questions/data/GroqProvider.dart';
import 'package:quiz_questions/data/models/QuizQuestion.dart';
import 'package:quiz_questions/data/models/QuizResult.dart';
import 'package:quiz_questions/utility/StorageService.dart';

class QuizController extends GetxController {
  late GroqProvider _groqProvider;

  final questions = <QuizQuestion>[].obs;
  final currentQuestionIndex = 0.obs;
  final score = 0.obs;
  final isLoading = true.obs;
  var isCorrect = false.obs;
  final errorMessage = ''.obs;

  // Timer related variables
  final enableTimer = false.obs;
  final timePerQuestion = 30.obs;
  final remainingTime = 0.obs;
  Timer? _timer;

  // Quiz metadata
  late String category;
  late String difficulty;

  @override
  void onInit() {
    super.onInit();

    // Extract arguments
    final args = Get.arguments as Map<String, dynamic>;
    final apiKey = args['apiKey'] as String;
    category = args['category'] as String;
    difficulty = args['difficulty'] as String;
    final questionCount = args['questionCount'] as int;
    enableTimer.value = args['enableTimer'] as bool;
    timePerQuestion.value = args['timePerQuestion'] as int;

    // Initialize the GROQ provider
    _groqProvider = GroqProvider(apiKey: apiKey);

    // Load questions
    loadQuestions(
      category: category,
      difficulty: difficulty,
      count: questionCount,
    );
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }

  Future<void> loadQuestions({
    required String category,
    required String difficulty,
    required int count,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Fetch questions from GROQ API
      final newQuestions = await _groqProvider.generateQuestions(
        category: category,
        difficulty: difficulty,
        count: count,
      );

      if (newQuestions.isEmpty) {
        errorMessage.value = 'No questions were generated. Please try again.';
        return;
      }

      // Update questions list
      questions.value = newQuestions;
      currentQuestionIndex.value = 0;
      score.value = 0;

      // Start timer if enabled
      if (enableTimer.value) {
        _startTimer();
      }
    } catch (e) {
      errorMessage.value = 'Error loading questions: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _startTimer() {
    remainingTime.value = timePerQuestion.value;
    _stopTimer(); // Ensure any existing timer is stopped

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        // Time's up, move to next question
        _handleTimeUp();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _handleTimeUp() {
    // Mark current question as incorrect (no answer selected)
    final currentQuestion = questions[currentQuestionIndex.value];
    currentQuestion.selectedAnswerIndex = -1; // Special value for timeout

    // Move to next question
    _moveToNextQuestion();
  }
  var selectedIndex = (-1).obs;
  void selectAnswer(int answerIndex) {
    if (isLoading.value) return;

    final currentQuestion = questions[currentQuestionIndex.value];

    // Skip if already answered
    if (currentQuestion.isAnswered) return;

    // Update the selected answer
    currentQuestion.selectedAnswerIndex = answerIndex;

    // Update score if correct
    if (currentQuestion.isCorrect) {
      score.value++;

    }

    selectedIndex.value=answerIndex;
    Future.delayed(const Duration(milliseconds: 750), () {
      selectedIndex.value=-1;
      _moveToNextQuestion();
      isCorrect=false.obs;
    });
  }

  void _moveToNextQuestion() {
    _stopTimer(); // Stop the current timer

    // Check if there are more questions
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;

      // Start timer for next question if enabled
      if (enableTimer.value) {
        _startTimer();
      }
    } else {
      // Quiz is complete
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    // Save quiz result
    final result = QuizResult(
      totalQuestions: questions.length,
      correctAnswers: score.value,
      dateTime: DateTime.now(),
      category: category,
      difficulty: difficulty,
    );

    Get.find<StorageService>().saveQuizResult(result);

    // Navigate to results screen
    Get.toNamed('/results', arguments: result);
  }

  void retryQuiz() {
    loadQuestions(
      category: category,
      difficulty: difficulty,
      count: questions.length,
    );
  }

  QuizQuestion get currentQuestion => questions[currentQuestionIndex.value];
}
