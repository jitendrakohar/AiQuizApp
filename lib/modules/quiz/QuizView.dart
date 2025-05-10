import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_questions/modules/quiz/QuizController.dart';
import 'package:quiz_questions/utility/AppTheme.dart';

class QuizView extends GetView<QuizController> {
  QuizView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${controller.category} Quiz',
          style: const TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          // Display score in appbar
          Obx(() => Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    'Score: ${controller.score.value}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingView();
            } else if (controller.errorMessage.value.isNotEmpty) {
              return _buildErrorView();
            } else if (controller.questions.isEmpty) {
              return _buildNoQuestionsView();
            } else {
              return _buildQuizView();
            }
          }),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Generating quiz questions...',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'This may take a few seconds',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.errorMessage.value,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.loadQuestions(
              category: controller.category,
              difficulty: controller.difficulty,
              count: 5,
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: AppTheme.primaryButtonStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildNoQuestionsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.help_outline,
            size: 64,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Questions Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Unable to generate quiz questions. Please try again or select a different category.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.loadQuestions(
              category: controller.category,
              difficulty: controller.difficulty,
              count: 5,
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: AppTheme.primaryButtonStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildQuizView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress indicator
        Obx(() => LinearProgressIndicator(
              value: (controller.currentQuestionIndex.value + 1) /
                  controller.questions.length,
              backgroundColor: Colors.grey[300],
              color: Theme.of(Get.context!).primaryColor,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            )),
        const SizedBox(height: 8),

        // Question counter
        Obx(() => Text(
              'Question ${controller.currentQuestionIndex.value + 1}/${controller.questions.length}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )),
        const SizedBox(height: 4),

        // Timer (if enabled)
        Obx(() => controller.enableTimer.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Time: ${controller.remainingTime.value}s',
                    style: TextStyle(
                      fontSize: 14,
                      color: controller.remainingTime.value <= 5
                          ? Colors.red
                          : Colors.black87,
                      fontWeight: controller.remainingTime.value <= 5
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              )
            : const SizedBox()),
        const SizedBox(height: 16),

        // Question card
        Expanded(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question text
                  Obx(() => Text(
                        controller.currentQuestion.question,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(height: 24),

                  // Answer options
                  Expanded(
                    child: SingleChildScrollView(
                      child: Obx(() => Column(
                            children: List.generate(
                              controller.currentQuestion.options.length,
                              (index) => _buildAnswerOption(index),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom navigation
        const SizedBox(height: 16),
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip button (enabled if not the last question)
                TextButton.icon(
                  onPressed: controller.currentQuestionIndex.value <
                          controller.questions.length - 1
                      ? () => controller.selectAnswer(-1) // Skip this question
                      : null,
                  icon: const Icon(Icons.skip_next),
                  label: const Text('Skip'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                  ),
                ),

                // Retry quiz button
                TextButton.icon(
                  onPressed: controller.retryQuiz,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Restart'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildAnswerOption(int index) {
    return Obx(() {
      final currentQuestion = controller.currentQuestion;
      final isSelected = currentQuestion.selectedAnswerIndex == index;
      final isCorrect = index == currentQuestion.correctAnswerIndex;
      final isAnswered = currentQuestion.isAnswered;

      // Determine the background color based on selection and correctness
      Color? backgroundColor;
      if (isAnswered) {
        if (isSelected && isCorrect) {
          backgroundColor = Colors.green[100]; // Correct answer selected
        } else if (isSelected && !isCorrect) {
          backgroundColor = Colors.red[100]; // Wrong answer selected
        } else if (isCorrect) {
          backgroundColor = Colors.green[50]; // Show correct answer
        }
      }

      // Determine the border color
      Color borderColor = isSelected
          ? (isCorrect ? Colors.green : Colors.red)
          : (isAnswered && isCorrect ? Colors.green : Colors.grey[300]!);

      return Padding(
        padding: EdgeInsets.only(bottom: 12.0),
        child: InkWell(
          onTap: () {
            print("is Questions: ${controller.isCorrect}");
            if (!isAnswered) {
              controller.selectAnswer(index);
            }
          },

          // isAnswered ? null : () =>
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                  color: controller.selectedIndex.value == index
                      ? Colors.red
                      : borderColor,
                  width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Option letter (A, B, C, D)
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isSelected ? borderColor : Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Option text
                Expanded(
                  child: Text(
                    currentQuestion.options[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isCorrect && isAnswered
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),

                // Correct/incorrect indicator
                if (isAnswered)
                  Icon(
                    isCorrect
                        ? Icons.check_circle
                        : (index == controller.selectedIndex.value
                            ? Icons.cancel
                            : null),
                    color: isCorrect ? Colors.green : Colors.red,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
