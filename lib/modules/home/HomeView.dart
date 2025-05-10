import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_questions/modules/home/HomeController.dart';
import 'package:quiz_questions/utility/AppConstants.dart';
import 'package:quiz_questions/utility/AppTheme.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  const SizedBox(height: 20),
                  const Text(
                    'Quiz Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  
                  // API Key section
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'GROQ API Key',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Obx(() => TextButton.icon(
                                onPressed: controller.toggleApiKeyVisibility,
                                icon: Icon(
                                  controller.showApiKeyField.value 
                                    ? Icons.visibility_off 
                                    : Icons.visibility,
                                ),
                                label: Text(
                                  controller.showApiKeyField.value ? 'Hide' : 'Edit',
                                ),
                              )),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Obx(() => controller.showApiKeyField.value
                            ? TextFormField(
                                controller: controller.apiKeyController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter your GROQ API Key',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your GROQ API Key';
                                  }
                                  return null;
                                },
                                obscureText: true,
                              )
                            : const Text(
                                '• • • • • • • • • • • • • • • •',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Quiz configuration section
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quiz Configuration',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Category selector
                          const Text('Category:'),
                          const SizedBox(height: 8),
                          Obx(() => DropdownButtonFormField<String>(
                            value: controller.selectedCategory.value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            items: AppConstants.quizCategories
                                .map((category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    ))
                                .toList(),
                            onChanged: controller.updateCategory,
                          )),
                          const SizedBox(height: 16),
                          
                          // Difficulty selector
                          const Text('Difficulty:'),
                          const SizedBox(height: 8),
                          Obx(() => DropdownButtonFormField<String>(
                            value: controller.selectedDifficulty.value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            items: AppConstants.difficultyLevels
                                .map((level) => DropdownMenuItem<String>(
                                      value: level,
                                      child: Text(level),
                                    ))
                                .toList(),
                            onChanged: controller.updateDifficulty,
                          )),
                          const SizedBox(height: 16),
                          
                          // Number of questions
                          const Text('Number of Questions:'),
                          const SizedBox(height: 8),
                          Obx(() => Slider(
                            value: controller.questionCount.value.toDouble(),
                            min: 3,
                            max: 10,
                            divisions: 7,
                            label: controller.questionCount.value.toString(),
                            onChanged: (value) => controller.updateQuestionCount(value.round()),
                          )),
                          Obx(() => Text(
                            'Questions: ${controller.questionCount.value}',
                            textAlign: TextAlign.center,
                          )),
                          const SizedBox(height: 16),
                          
                          // Timer settings
                          Row(
                            children: [
                              Obx(() => Switch(
                                value: controller.enableTimer.value,
                                onChanged: (_) => controller.toggleTimer(),
                              )),
                              const Text('Enable Timer'),
                            ],
                          ),
                          Obx(() => controller.enableTimer.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    const Text('Time per Question (seconds):'),
                                    Slider(
                                      value: controller.timePerQuestion.value.toDouble(),
                                      min: 10,
                                      max: 60,
                                      divisions: 10,
                                      label: controller.timePerQuestion.value.toString(),
                                      onChanged: (value) =>
                                          controller.updateTimePerQuestion(value.round()),
                                    ),
                                    Text(
                                      'Time: ${controller.timePerQuestion.value} seconds',
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                              : const SizedBox()),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Start Quiz button
                  Obx(() => ElevatedButton.icon(
                    style: AppTheme.primaryButtonStyle,
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.startQuiz,
                    icon: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.play_arrow),
                    label: Text(
                      controller.isLoading.value ? 'Loading...' : 'Start Quiz',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
                  
                  // Error message
                  Obx(() => controller.errorMessage.value.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            controller.errorMessage.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox()),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}