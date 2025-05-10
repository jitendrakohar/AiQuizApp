import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_questions/data/models/QuizQuestion.dart';

class GroqProvider {
  static const String _baseUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  late final String _apiKey;

  GroqProvider({required String apiKey}) {
    _apiKey = apiKey;
  }

  Future<List<QuizQuestion>> generateQuestions({
    String category = 'General Knowledge',
    String difficulty = 'Medium',
    int count = 5,
  }) async {
    try {
      final prompt = '''
Generate $count random multiple-choice questions on $category with $difficulty difficulty. 
Each should have a question, 4 options, and the correct answer clearly marked.
Return ONLY valid JSON in exactly this format, with no explanations or additional text:
{
  "questions": [
    {
      "question": "Question text here?",
      "options": ["Option A", "Option B", "Option C", "Option D"],
      "correctAnswer": "Option B"
    },
    ...more questions...
  ]
}
''';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'llama3-8b-8192',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a helpful assistant that generates quiz questions in the requested JSON format.'
            },
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
          'max_tokens': 2048,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final content = jsonResponse['choices'][0]['message']['content'];

        // Parse the content to extract JSON
        final jsonMatch = RegExp(r'{[\s\S]*}').firstMatch(content);

        if (jsonMatch != null) {
          final jsonContent = jsonDecode(jsonMatch.group(0)!);
          final questionsJson = jsonContent['questions'] as List<dynamic>;

          return questionsJson.map((q) => QuizQuestion.fromJson(q)).toList();
        } else {
          throw Exception('Invalid JSON format from API');
        }
      } else {
        throw Exception(
            'Failed to load questions: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating questions: $e');
    }
  }
}
