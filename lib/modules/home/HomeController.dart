import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_questions/routes/AppPages.dart';
import 'package:quiz_questions/modules/quiz/QuizView.dart';
import 'package:quiz_questions/utility/StorageService.dart';

class HomeController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final apiKeyController = TextEditingController();

  final selectedCategory = 'General Knowledge'.obs;
  final selectedDifficulty = 'Medium'.obs;
  final questionCount = 5.obs;
  final enableTimer = false.obs;
  final timePerQuestion = 30.obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final showApiKeyField = true.obs;

  @override
  void onInit() {
    super.onInit();
    // try {
    loadApiKey();
    // } catch (e) {
    //   print("exception thrown: $e");
    // }
  }

  @override
  void onClose() {
    apiKeyController.dispose();
    super.onClose();
  }

  void loadApiKey() {
    final apiKey = Get.find<StorageService>().getApiKey();
    if (apiKey != null && apiKey.isNotEmpty) {
      apiKeyController.text = apiKey;
      showApiKeyField.value = false;
    }
  }

  void toggleApiKeyVisibility() {
    showApiKeyField.toggle();
  }

  void updateCategory(String? category) {
    if (category != null) {
      selectedCategory.value = category;
    }
  }

  void updateDifficulty(String? difficulty) {
    if (difficulty != null) {
      selectedDifficulty.value = difficulty;
    }
  }

  void updateQuestionCount(int count) {
    questionCount.value = count;
  }

  void toggleTimer() {
    enableTimer.toggle();
  }

  void updateTimePerQuestion(int seconds) {
    timePerQuestion.value = seconds;
  }

  Future<void> startQuiz() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final apiKey = apiKeyController.text.trim();
    if (apiKey.isEmpty) {
      errorMessage.value = 'Please enter your GROQ API key';
      return;
    }
    if(selectedCategory.isEmpty){
      print("selected category not found: ${selectedCategory}");
    }
    else{
      print("selected category found: ${selectedCategory}");
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Save API key
      await Get.find<StorageService>().saveApiKey(apiKey);

      // Navigate to Quiz screen
      Get.toNamed(Routes.QUIZ, arguments: {
        'apiKey': apiKey,
        'category': selectedCategory.value,
        'difficulty': selectedDifficulty.value,
        'questionCount': questionCount.value,
        'enableTimer': enableTimer.value,
        'timePerQuestion': timePerQuestion.value,
      });
    } catch (e) {
      errorMessage.value = 'Error starting quiz: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
