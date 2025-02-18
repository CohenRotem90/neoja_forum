import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // baseUrl for local run
  // static String baseUrl = 'http://localhost:5000';
  // baseUrl for docker run
  static String baseUrl = "http://localhost:5000 ";


  // Get list of questions
  static Future<List<dynamic>> getQuestions() async {
    var response = await http.get(Uri.parse('$baseUrl/questions'));
    return json.decode(response.body);
  }

  // Get a single question
  static Future<Map<String, dynamic>> getQuestion(String questionId) async {
    var response = await http.get(Uri.parse('$baseUrl/questions/$questionId'));
    return json.decode(response.body);
  }

  // Create a new question
  static Future<void> createQuestion(String title, String content) async {
    await http.post(
      Uri.parse('$baseUrl/questions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'content': content}),
    );
  }

  // Add an answer to a question
  static Future<void> addAnswer(String questionId, String content) async {
    await http.post(
      Uri.parse('$baseUrl/questions/$questionId/answers'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'content': content}),
    );
  }
}
