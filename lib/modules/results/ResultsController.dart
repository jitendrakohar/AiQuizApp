import 'package:get/get.dart';
import 'package:quiz_questions/data/models/QuizResult.dart';
import 'package:quiz_questions/utility/StorageService.dart';


class ResultsController extends GetxController {
  final quizResult = Rx<QuizResult?>(null);
  final pastResults = <QuizResult>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // Get current quiz result
    if (Get.arguments is QuizResult) {
      quizResult.value = Get.arguments as QuizResult;
    }
    
    // Load past results
    loadPastResults();
  }
  
  void loadPastResults() {
    final results = Get.find<StorageService>().getQuizResults();
    
    // Sort by date (newest first)
    results.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    
    pastResults.value = results;
  }
  
  void startNewQuiz() {
    Get.offAllNamed('/home');
  }
  
  void retryQuiz() {
    Get.back();
  }
  
  String getPerformanceMessage() {
    if (quizResult.value == null) return '';
    
    final percentage = quizResult.value!.percentage;
    
    if (percentage >= 90) {
      return 'Excellent! You\'re a quiz master!';
    } else if (percentage >= 70) {
      return 'Great job! You did really well!';
    } else if (percentage >= 50) {
      return 'Good effort! Keep practicing!';
    } else if (percentage >= 30) {
      return 'Keep learning! You\'ll improve with practice.';
    } else {
      return 'Don\'t give up! Try again to improve your score.';
    }
  }
  
  String getGrade() {
    if (quizResult.value == null) return '';
    
    final percentage = quizResult.value!.percentage;
    
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'F';
  }
}