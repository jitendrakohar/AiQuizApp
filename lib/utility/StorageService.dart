import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quiz_questions/data/models/QuizResult.dart';

class StorageService extends GetxService {
  late final GetStorage _box;
  static const String _resultsKey = 'quiz_results';
  static const String _apiKeyKey = 'groq_api_key';


  Future<StorageService> init() async {

    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  Future<void> saveApiKey(String apiKey) async {
    await _box.write(_apiKeyKey, apiKey);
  }

  String? getApiKey() {
    _box = GetStorage();
    return _box.read<String>(_apiKeyKey);
  }

  Future<void> saveQuizResult(QuizResult result) async {
    List<QuizResult> results = getQuizResults();
    results.add(result);

    final jsonResults = results.map((r) => r.toJson()).toList();
    await _box.write(_resultsKey, jsonEncode(jsonResults));
  }

  List<QuizResult> getQuizResults() {
    final resultsJson = _box.read<String>(_resultsKey);
    
    if (resultsJson == null) {
      return [];
    }
    
    try {
      final List<dynamic> jsonList = jsonDecode(resultsJson);
      return jsonList.map((json) => QuizResult.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Clear all quiz results
  Future<void> clearQuizResults() async {
    await _box.remove(_resultsKey);
  }
}