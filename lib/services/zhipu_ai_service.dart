import 'dart:convert';

import 'package:http/http.dart' as http;

class ZhipuAiService {
  ZhipuAiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _apiKey =
      'd25ff527120d490c8a7007efe4d8432c.zpNd5Qx3vAgMIYvf'; // provided by user
  static const _endpoint =
      'https://open.bigmodel.cn/api/paas/v4/chat/completions';
  static const _model = 'glm-4-flash';

  Future<String> sendChat({
    required String characterName,
    required List<Map<String, String>> history,
  }) async {
    final messages = <Map<String, String>>[
      {
        'role': 'system',
        'content':
            'You are $characterName, an empathetic travel companion. Always reply in English, stay concise and positive, and avoid mentioning any specific geo locations unless the user provides them first.'
      },
      ...history,
    ];

    final response = await _client.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': _model,
        'messages': messages,
        'temperature': 0.8,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('AI request failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw Exception('AI response malformed');
    }

    final message = choices.first['message'] as Map<String, dynamic>?;
    final content = message?['content'] as String?;
    if (content == null || content.isEmpty) {
      throw Exception('AI response missing content');
    }

    return content.trim();
  }

  void dispose() {
    _client.close();
  }
}

