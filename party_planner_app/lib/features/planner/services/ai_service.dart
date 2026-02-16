import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  final String _apiKey;

  AIService({String? apiKey}) 
      // TODO: Replace with secure API key handling (e.g., flutter_dotenv)
      : _apiKey = apiKey ?? 'YOUR_OPENROUTER_API_KEY';

  Future<String> generateEventPlan(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://partyplanner.app', // Required by OpenRouter
          'X-Title': 'PartyPlanner', // Optional
        },
        body: jsonEncode({
          'model': 'google/gemini-2.0-flash-lite-preview-02-05:free', // Use a free model for testing
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful event planner assistant. '
                  'Generate a detailed event plan based on the user request. '
                  'Include a schedule, item list, and venue suggestions if applicable.'
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ?? 'No plan generated.';
      } else {
        throw Exception('Failed to generate plan: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error calling AI Service: $e');
    }
  }
}
