
// lib/utils/constants.dart
class AppConstants {
  static const String appName = 'Psychology Assistant';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';
  static const int maxConversationHistory = 10;
  static const int maxResponseTokens = 1024;
  
  // UI Configuration
  static const double messageBorderRadius = 20.0;
  static const double inputBorderRadius = 24.0;
  static const double cardBorderRadius = 12.0;
  
  // Psychology-specific prompts
  static const String systemPrompt = '''
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
''';

  static const List<String> emergencyKeywords = [
    'suicide',
    'kill myself',
    'end my life',
    'hurt myself',
    'self harm',
    'want to die',
    'better off dead',
  ];

  static const String emergencyResponse = '''
I'm very concerned about what you're sharing. Your safety is the most important thing right now. Please consider:

🆘 **Immediate Help:**
• National Suicide Prevention Lifeline: 988 (US)
• Crisis Text Line: Text HOME to 741741
• Emergency Services: 911

🏥 **Professional Support:**
• Contact a mental health professional
• Visit your nearest emergency room
• Reach out to a trusted friend or family member

Remember: You are not alone, and there are people who want to help you. These feelings can change with proper support and treatment.

Would you like to talk about what's making you feel this way, or would you prefer resources for professional help?
''';
}
