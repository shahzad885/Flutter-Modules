
// lib/utils/text_utils.dart
import 'package:sky/chatbot/Utils/AppConstants.dart';

class TextUtils {
  /// Check if message contains emergency keywords
  static bool containsEmergencyKeywords(String text) {
    final lowerText = text.toLowerCase();
    return AppConstants.emergencyKeywords.any((keyword) => 
        lowerText.contains(keyword.toLowerCase()));
  }

  /// Clean and format message text
  static String cleanMessage(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Format timestamp for display
  static String formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  /// Truncate text with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}