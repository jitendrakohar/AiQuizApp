import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quiz_questions/modules/results/ResultsController.dart';
import 'package:quiz_questions/routes/AppPages.dart';
import 'package:quiz_questions/utility/AppConstants.dart';
import 'package:quiz_questions/utility/AppTheme.dart';

class ResultsView extends GetView<ResultsController> {
  const ResultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Get.toNamed(Routes.HOME);
            },
            child: Icon(
              Icons.arrow_back,
            )),
        title: const Text('Quiz Results'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Results card
              Obx(() => controller.quizResult.value != null
                  ? _buildResultCard()
                  : const SizedBox()),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.retryQuiz,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: AppTheme.primaryButtonStyle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.startNewQuiz,
                      icon: const Icon(Icons.home),
                      label: const Text('New Quiz'),
                      style: AppTheme.successButtonStyle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Past results heading
              const Text(
                'Previous Results',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Past results list
              Expanded(
                child: Obx(() => controller.pastResults.isEmpty
                    ? const Center(
                        child: Text(
                          'No previous results',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.pastResults.length,
                        itemBuilder: (context, index) {
                          final result = controller.pastResults[index];
                          final isCurrentResult =
                              controller.quizResult.value != null &&
                                  controller.quizResult.value!.dateTime ==
                                      result.dateTime;

                          return Card(
                            elevation: isCurrentResult ? 4 : 2,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: isCurrentResult
                                  ? BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2)
                                  : BorderSide.none,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${result.category} - ${result.difficulty}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${result.correctAnswers}/${result.totalQuestions}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          _getColorForScore(result.percentage),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('MMM d, y - HH:mm')
                                        .format(result.dateTime),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '${result.percentage.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          _getColorForScore(result.percentage),
                                    ),
                                  ),
                                ],
                              ),
                              leading: CircleAvatar(
                                backgroundColor:
                                    _getColorForScore(result.percentage)
                                        .withOpacity(0.2),
                                child: Text(
                                  _getGradeForScore(result.percentage),
                                  style: TextStyle(
                                    color: _getColorForScore(result.percentage),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              trailing: isCurrentResult
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : null,
                            ),
                          );
                        },
                      )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final result = controller.quizResult.value!;
    final percentage = result.percentage;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Result header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quiz Complete!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${result.category} - ${result.difficulty}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor:
                      _getColorForScore(percentage).withOpacity(0.2),
                  child: Text(
                    controller.getGrade(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getColorForScore(percentage),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Score display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildScoreIndicator(percentage),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: _getColorForScore(percentage),
                      ),
                    ),
                    Text(
                      '${result.correctAnswers}/${result.totalQuestions} correct',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Feedback message
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                controller.getPerformanceMessage(),
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreIndicator(double percentage) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        children: [
          CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 8,
            backgroundColor: Colors.grey[300],
            color: _getColorForScore(percentage),
          ),
          Center(
            child: Icon(
              _getIconForScore(percentage),
              size: 32,
              color: _getColorForScore(percentage),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForScore(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.blue;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }

  IconData _getIconForScore(double percentage) {
    if (percentage >= 80) return Icons.sentiment_very_satisfied;
    if (percentage >= 60) return Icons.sentiment_satisfied;
    if (percentage >= 40) return Icons.sentiment_neutral;
    return Icons.sentiment_dissatisfied;
  }

  String _getGradeForScore(double percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'c';
    if (percentage >= 50) return 'D';
    return 'Fail';
  }
}
