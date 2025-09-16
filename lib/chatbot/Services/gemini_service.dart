// lib/services/gemini_service.dart (Simplified Version)
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sky/chatbot/Models/gemini_response.dart';

class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';
  
  late final String _apiKey;
  final http.Client _client;

  GeminiService({http.Client? client}) : _client = client ?? http.Client() {
    _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (_apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in environment variables');
    }
  }

  /// Generate a response from Gemini AI with psychology context
  Future<String> generateResponse(String userMessage, List<String> conversationHistory) async {
    try {
      final prompt = _buildPsychologyPrompt(userMessage, conversationHistory);
      
      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.7,
          "topK": 40,
          "topP": 0.95,
          "maxOutputTokens": 1024,
        },
        "safetySettings": [
          {
            "category": "HARM_CATEGORY_HARASSMENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_HATE_SPEECH",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          }
        ]
      };

      final response = await _client.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final geminiResponse = GeminiResponse.fromJson(jsonResponse);
        
        if (geminiResponse.success) {
          return geminiResponse.text;
        } else {
          throw Exception(geminiResponse.error ?? 'Unknown error occurred');
        }
      } else {
        throw HttpException('API request failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating response: $e');
    }
  }

  /// Build a psychology-focused prompt with context
  String _buildPsychologyPrompt(String userMessage, List<String> conversationHistory) {
    final contextPrompt = '''
You are a professional psychology assistant designed to provide supportive, empathetic, and helpful guidance. Your role is to:

1. Listen actively and respond with empathy
2. Provide evidence-based psychological insights when appropriate
3. Encourage healthy coping mechanisms and positive thinking patterns
4. Recognize when professional help might be beneficial and suggest it appropriately
5. Maintain professional boundaries while being warm and supportive
6. Never provide medical diagnoses or replace professional therapy

Important guidelines:
- Always be respectful, non-judgmental, and supportive
- Use active listening techniques in your responses
- Ask clarifying questions when helpful
- Provide practical coping strategies and techniques
- Encourage self-reflection and personal growth
- If someone expresses thoughts of self-harm, prioritize their safety and suggest professional help

Conversation history:
${conversationHistory.isNotEmpty ? conversationHistory.join('\n') : 'This is the beginning of the conversation.'}

Current user message: $userMessage

Please respond as a caring psychology assistant, keeping your response helpful, supportive, and professional.
''';

    return contextPrompt;
  }

  void dispose() {
    _client.close();
  }
}