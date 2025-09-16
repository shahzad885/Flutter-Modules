// lib/providers/chat_provider.dart
import 'package:flutter/foundation.dart';
import 'package:sky/chatbot/Models/chat_message.dart';
import 'package:sky/chatbot/Services/gemini_service.dart';
import 'package:uuid/uuid.dart';

enum ChatState { idle, loading, error }

class ChatProvider with ChangeNotifier {
  final GeminiService _geminiService;
  final List<ChatMessageModel> _messages = [];
  final List<String> _conversationHistory = [];
  
  ChatState _state = ChatState.idle;
  String _errorMessage = '';
  bool _isTyping = false;

  ChatProvider({GeminiService? geminiService}) 
      : _geminiService = geminiService ?? GeminiService() {
    _initializeChat();
  }

  // Getters
  List<ChatMessageModel> get messages => List.unmodifiable(_messages);
  ChatState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isTyping => _isTyping;
  bool get hasMessages => _messages.isNotEmpty;

  /// Initialize chat with welcome message
  void _initializeChat() {
    final welcomeMessage = ChatMessageModel.fromAssistant(
      id: const Uuid().v4(),
      text: "Hello! I'm your psychology assistant. I'm here to listen and provide support. How are you feeling today?",
      createdAt: DateTime.now(),
    );
    
    _messages.add(welcomeMessage);
    notifyListeners();
  }

  /// Send a user message and get AI response
  Future<void> sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return;

    try {
      _setState(ChatState.loading);
      _setTyping(true);
      
      // Add user message
      final userMessage = ChatMessageModel.fromUser(
        id: const Uuid().v4(),
        text: messageText.trim(),
        createdAt: DateTime.now(),
      );
      
      _addMessage(userMessage);
      _addToConversationHistory('User: ${messageText.trim()}');
      
      // Get AI response
      final response = await _geminiService.generateResponse(
        messageText.trim(),
        _conversationHistory,
      );
      
      // Add AI response
      final assistantMessage = ChatMessageModel.fromAssistant(
        id: const Uuid().v4(),
        text: response,
        createdAt: DateTime.now(),
      );
      
      _addMessage(assistantMessage);
      _addToConversationHistory('Assistant: $response');
      
      _setState(ChatState.idle);
      
    } catch (e) {
      _setError('Failed to send message: ${e.toString()}');
      
      // Add error message for user feedback
      final errorMessage = ChatMessageModel.fromAssistant(
        id: const Uuid().v4(),
        text: "I'm sorry, I'm having trouble responding right now. Please try again in a moment.",
        createdAt: DateTime.now(),
      );
      
      _addMessage(errorMessage);
    } finally {
      _setTyping(false);
    }
  }

  /// Add message to the conversation
  void _addMessage(ChatMessageModel message) {
    _messages.insert(0, message); // Insert at beginning for reverse chronological order
    notifyListeners();
  }

  /// Add to conversation history for context
  void _addToConversationHistory(String entry) {
    _conversationHistory.add(entry);
    
    // Keep only last 10 entries to manage context length
    if (_conversationHistory.length > 10) {
      _conversationHistory.removeAt(0);
    }
  }

  /// Set the current state
  void _setState(ChatState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  /// Set typing indicator
  void _setTyping(bool typing) {
    if (_isTyping != typing) {
      _isTyping = typing;
      notifyListeners();
    }
  }

  /// Set error message and state
  void _setError(String error) {
    _errorMessage = error;
    _setState(ChatState.error);
    
    if (kDebugMode) {
      print('ChatProvider Error: $error');
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = '';
    if (_state == ChatState.error) {
      _setState(ChatState.idle);
    }
  }

  /// Clear all messages and restart chat
  void clearChat() {
    _messages.clear();
    _conversationHistory.clear();
    _setState(ChatState.idle);
    _initializeChat();
  }

  /// Retry last message if there was an error
  Future<void> retryLastMessage() async {
    if (_messages.length >= 2 && _messages[1].isUser) {
      final lastUserMessage = _messages[1].text;
      await sendMessage(lastUserMessage);
    }
  }

  @override
  void dispose() {
    _geminiService.dispose();
    super.dispose();
  }
}