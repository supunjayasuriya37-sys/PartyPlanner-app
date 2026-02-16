import 'dart:convert';
import 'package:http/http.dart' as http;

class AiPlannerService {
  // TODO: Secure this key properly (e.g., Firebase Remote Config or .env)
  // For development, we might need to ask the user to input it or pass it from build config.
  final String _apiKey = 'YOUR_OPENROUTER_API_KEY'; 
  final String _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  Future<Map<String, dynamic>> planEvent(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://partyplanner.app', // Required by OpenRouter
        },
        body: jsonEncode({
          'model': 'google/gemma-7b-it:free', // Or generic model
          'messages': [
            {
              'role': 'system',
              'content': 'You are an expert event planner. Output ONLY valid JSON.',
            },
            {
              'role': 'user',
              'content': 'Plan an event: $prompt',
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        // TODO: Parse the content primarily if it's markdown code block
        return jsonDecode(content); // simplistic parsing
      } else {
        throw Exception('Failed to plan event: ${response.body}');
      }
    } catch (e) {
      throw Exception('AI Service Error: $e');
    }
  }
}
