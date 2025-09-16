class GeminiResponse {
  final String text;
  final bool success;
  final String? error;

  GeminiResponse({
    required this.text,
    required this.success,
    this.error,
  });

  factory GeminiResponse.success(String text) {
    return GeminiResponse(
      text: text,
      success: true,
    );
  }

  factory GeminiResponse.error(String error) {
    return GeminiResponse(
      text: '',
      success: false,
      error: error,
    );
  }

  factory GeminiResponse.fromJson(Map<String, dynamic> json) {
    try {
      final candidates = json['candidates'] as List?;
      if (candidates != null && candidates.isNotEmpty) {
        final firstCandidate = candidates[0] as Map<String, dynamic>;
        final content = firstCandidate['content'] as Map<String, dynamic>;
        final parts = content['parts'] as List;
        if (parts.isNotEmpty) {
          final text = parts[0]['text'] as String;
          return GeminiResponse.success(text);
        }
      }
      return GeminiResponse.error('No valid response found');
    } catch (e) {
      return GeminiResponse.error('Failed to parse response: $e');
    }
  }
}