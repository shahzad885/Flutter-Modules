// // lib/screens/chat_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:sky/chatbot/Providers/providers.dart';
// import 'package:sky/chatbot/Widgets/error_message_widget.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   late final ChatUser _currentUser;
//   late final ChatUser _psychologyAssistant;

//   @override
//   void initState() {
//     super.initState();
//     _currentUser = ChatUser(
//       id: 'user',
//       firstName: 'You',
//     );
//     _psychologyAssistant = ChatUser(
//       id: 'assistant',
//       firstName: 'Psychology Assistant',
//        profileImage: 'https://ui-avatars.com/api/?name=PA&background=2196F3&color=fff',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Psychology Assistant'),
//         backgroundColor: Theme.of(context).primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 2,
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: _handleMenuAction,
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 value: 'clear',
//                 child: Row(
//                   children: [
//                     Icon(Icons.clear_all),
//                     SizedBox(width: 8),
//                     Text('Clear Chat'),
//                   ],
//                 ),
//               ),
//               const PopupMenuItem(
//                 value: 'about',
//                 child: Row(
//                   children: [
//                     Icon(Icons.info_outline),
//                     SizedBox(width: 8),
//                     Text('About'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Consumer<ChatProvider>(
//         builder: (context, chatProvider, child) {
//           return Column(
//             children: [
//               // Error message display
//               if (chatProvider.state == ChatState.error)
//                 ErrorMessageWidget(
//                   message: chatProvider.errorMessage,
//                   onRetry: () => chatProvider.retryLastMessage(),
//                   onDismiss: () => chatProvider.clearError(),
//                 ),
              
//               // Chat messages area
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.blue.shade50,
//                         Colors.white,
//                       ],
//                     ),
//                   ),
//                   child: DashChat(
//                     currentUser: _currentUser,
//                     onSend: (message) => _handleSendMessage(context, message),
//                     messages: _convertMessages(chatProvider.messages),
//                     messageOptions: MessageOptions(
//                       showCurrentUserAvatar: true,
//                       showOtherUsersAvatar: true,
//                       showTime: true,
//                       currentUserContainerColor: Theme.of(context).primaryColor,
//                       containerColor: Colors.grey.shade100,
//                       textColor: Colors.black87,
//                       currentUserTextColor: Colors.white,
//                       messagePadding: const EdgeInsets.all(12),
//                       messageTextBuilder: _customMessageBuilder,
//                     ),
//                     inputOptions: InputOptions(
//                       inputDisabled: chatProvider.state == ChatState.loading,
//                       alwaysShowSend: true,
//                       sendButtonBuilder: (onSend) => IconButton(
//                         onPressed: chatProvider.state == ChatState.loading ? null : onSend,
//                         icon: chatProvider.state == ChatState.loading
//                             ? const SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(strokeWidth: 2),
//                               )
//                             : const Icon(Icons.send),
//                         color: Theme.of(context).primaryColor,
//                       ),
//                       inputDecoration: InputDecoration(
//                         hintText: chatProvider.state == ChatState.loading 
//                             ? 'AI is thinking...' 
//                             : 'Type your message...',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           borderSide: BorderSide(color: Colors.grey.shade300),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           borderSide: BorderSide(color: Theme.of(context).primaryColor),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 12,
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                       ),
//                     ),
//                     messageListOptions: MessageListOptions(
//                       separatorFrequency: SeparatorFrequency.days,
//                       dateSeparatorBuilder: (date) => Container(
//                         margin: const EdgeInsets.symmetric(vertical: 16),
//                         child: Center(
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade300,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               _formatDate(date),
//                               style: TextStyle(
//                                 color: Colors.grey.shade700,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     typingUsers: chatProvider.isTyping ? [_psychologyAssistant] : [],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   void _handleSendMessage(BuildContext context, ChatMessage message) {
//     final chatProvider = Provider.of<ChatProvider>(context, listen: false);
//     chatProvider.sendMessage(message.text);
//   }

//   List<ChatMessage> _convertMessages(List<dynamic> messages) {
//     return messages.map((msg) {
//       // Convert your ChatMessageModel to DashChat's ChatMessage
//       return msg.toDashChatMessage(
//         currentUser: _currentUser,
//         assistantUser: _psychologyAssistant,
//       );
//     }).cast<ChatMessage>().toList();
//   }

//   Widget _customMessageBuilder(ChatMessage message, ChatMessage? previousMessage, ChatMessage? nextMessage) {
//     return Container(
//       constraints: BoxConstraints(
//         maxWidth: MediaQuery.of(context).size.width * 0.8,
//       ),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: message.user.id == _currentUser.id 
//             ? Theme.of(context).primaryColor 
//             : Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         message.text,
//         style: TextStyle(
//           color: message.user.id == _currentUser.id ? Colors.white : Colors.black87,
//           fontSize: 16,
//           height: 1.4,
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final messageDate = DateTime(date.year, date.month, date.day); // Fixed bug: was date.year instead of date.day
    
//     if (messageDate == today) {
//       return 'Today';
//     } else if (messageDate == today.subtract(const Duration(days: 1))) {
//       return 'Yesterday';
//     } else {
//       return '${date.day}/${date.month}/${date.year}';
//     }
//   }

//   void _handleMenuAction(String action) {
//     final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
//     switch (action) {
//       case 'clear':
//         _showClearChatDialog(chatProvider);
//         break;
//       case 'about':
//         _showAboutDialog();
//         break;
//     }
//   }

//   void _showClearChatDialog(ChatProvider chatProvider) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Clear Chat'),
//         content: const Text('Are you sure you want to clear all messages? This action cannot be undone.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               chatProvider.clearChat();
//               Navigator.of(context).pop();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Clear'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showAboutDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('About Psychology Assistant'),
//         content: const Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'This AI assistant is designed to provide supportive psychological guidance and conversation.',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Important Notice:',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               '• This is not a replacement for professional therapy\n'
//               '• For mental health emergencies, contact emergency services\n'
//               '• Consider consulting a licensed mental health professional for ongoing support',
//               style: TextStyle(fontSize: 14),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Got it'),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky/chatbot/Providers/providers.dart';
import 'package:sky/chatbot/Widgets/DotTypingAnimation.dart';
import 'package:sky/chatbot/Widgets/error_message_widget.dart';
import 'package:intl/intl.dart';

class ChatbotHelpScreen extends StatefulWidget {
  const ChatbotHelpScreen({super.key});

  @override
  State<ChatbotHelpScreen> createState() => _ChatbotHelpScreenState();
}

class _ChatbotHelpScreenState extends State<ChatbotHelpScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(ChatProvider provider, String text) {
    if (text.trim().isEmpty || provider.state == ChatState.loading) return;
    provider.sendMessage(text);
    _textController.clear();
    _scrollToBottom();
  }

  Widget _buildSuggestionChip(String text, ChatProvider provider) {
    return ElevatedButton.icon(
      onPressed: () => _sendMessage(provider, text),
      icon: const Icon(Icons.bolt, size: 14),
      label: Text(text, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        elevation: 4,
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildMessage(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? Theme.of(context).primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(2, 2),
              blurRadius: 4,
            )
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF1F5F9),
          body: Column(
            children: [
              // Header
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.psychology, color: Colors.blue),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AI Therapy Assistant', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Online', style: TextStyle(fontSize: 12, color: Colors.green)),
                      ],
                    ),
                    const Spacer(),
                    Chip(
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, size: 14),
                          SizedBox(width: 4),
                          Text('AI Powered'),
                        ],
                      ),
                      backgroundColor: Colors.blue.shade50,
                      labelStyle: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),

              // Suggestion Buttons
              if (provider.messages.isEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildSuggestionChip("Show therapy tips", provider),
                      const SizedBox(width: 8),
                      _buildSuggestionChip("Find test instructions", provider),
                      const SizedBox(width: 8),
                      _buildSuggestionChip("Anxiety management", provider),
                      const SizedBox(width: 8),
                      _buildSuggestionChip("Patient communication", provider),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              // Error Message
              if (provider.state == ChatState.error)
                ErrorMessageWidget(
                  message: provider.errorMessage,
                  onRetry: () => provider.retryLastMessage(),
                  onDismiss: () => provider.clearError(),
                ),

              // Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.messages.length + (provider.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= provider.messages.length) {
                      return const Row(
                        children: [
                          CircleAvatar(radius: 14, backgroundColor: Colors.blue, child: Icon(Icons.psychology, size: 16, color: Colors.white)),
                          SizedBox(width: 8),
                          DotTypingAnimation(),
                        ],
                      );
                    }

                    final msg = provider.messages[index];
                    return _buildMessage(msg.text, msg.isUser);
                  },
                ),
              ),

              // Input
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        enabled: provider.state != ChatState.loading,
                        onSubmitted: (_) => _sendMessage(provider, _textController.text),
                        decoration: const InputDecoration.collapsed(hintText: "Ask me anything about therapy..."),
                      ),
                    ),
                    IconButton(
                      onPressed: provider.state == ChatState.loading
                          ? null
                          : () => _sendMessage(provider, _textController.text),
                      icon: provider.state == ChatState.loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
