// // lib/chatbot/Models/chat_message.dart
// import 'package:dash_chat_2/dash_chat_2.dart';

// class ChatMessageModel {
//   final String id;
//   final String text;
//   final bool isUser;
//   final DateTime createdAt;

//   ChatMessageModel({
//     required this.id,
//     required this.text,
//     required this.isUser,
//     required this.createdAt,
//   });

//   factory ChatMessageModel.fromUser({
//     required String id,
//     required String text,
//     required DateTime createdAt,
//   }) {
//     return ChatMessageModel(
//       id: id,
//       text: text,
//       isUser: true,
//       createdAt: createdAt,
//     );
//   }

//   factory ChatMessageModel.fromAssistant({
//     required String id,
//     required String text,
//     required DateTime createdAt,
//   }) {
//     return ChatMessageModel(
//       id: id,
//       text: text,
//       isUser: false,
//       createdAt: createdAt,
//     );
//   }

//   // Convert to DashChat message format
//   ChatMessage toDashChatMessage({
//     required ChatUser currentUser,
//     required ChatUser assistantUser,
//   }) {
//     return ChatMessage(
//       text: text,
//       user: isUser ? currentUser : assistantUser,
//       createdAt: createdAt,
//     );
//   }
// }

// lib/chatbot/Models/chat_message.dart
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatMessageModel {
  final String id;
  final String text;
  final bool isUser;
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.isUser,
    required this.createdAt,
  });

  factory ChatMessageModel.fromUser({
    required String id,
    required String text,
    required DateTime createdAt,
  }) {
    return ChatMessageModel(
      id: id,
      text: text,
      isUser: true,
      createdAt: createdAt,
    );
  }

  factory ChatMessageModel.fromAssistant({
    required String id,
    required String text,
    required DateTime createdAt,
  }) {
    return ChatMessageModel(
      id: id,
      text: text,
      isUser: false,
      createdAt: createdAt,
    );
  }

  // Convert to DashChat message format
  ChatMessage toDashChatMessage({
    required ChatUser currentUser,
    required ChatUser assistantUser,
  }) {
    return ChatMessage(
      text: text,
      user: isUser ? currentUser : assistantUser,
      createdAt: createdAt,
    );
  }
}