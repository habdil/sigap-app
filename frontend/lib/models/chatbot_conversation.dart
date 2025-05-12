// Path: lib/models/chatbot_conversation.dart
import 'package:frontend/models/chatbot_message.dart';

class ChatbotConversation {
  final int id;
  final int userId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final List<ChatbotMessage>? messages;

  ChatbotConversation({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    this.messages,
  });

  // Factory method untuk konversi dari JSON ke model dengan penanganan yang lebih robust
  factory ChatbotConversation.fromJson(Map<String, dynamic> json) {
    // Log untuk debugging
    print('Parsing conversation: ${json.keys}');

    // Parse messages jika ada
    List<ChatbotMessage>? messagesList;
    if (json.containsKey('messages') && json['messages'] != null) {
      try {
        messagesList = (json['messages'] as List)
            .map((msgJson) => ChatbotMessage.fromJson(msgJson))
            .toList();
      } catch (e) {
        print('Error parsing messages: $e');
        // Jika parsing messages gagal, biarkan messagesList null
      }
    }

    // Parse tanggal dengan penanganan error
    DateTime parsedCreatedAt;
    DateTime parsedUpdatedAt;
    
    try {
      parsedCreatedAt = DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String());
    } catch (e) {
      print('Error parsing created_at: $e');
      parsedCreatedAt = DateTime.now();
    }
    
    try {
      parsedUpdatedAt = DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String());
    } catch (e) {
      print('Error parsing updated_at: $e');
      parsedUpdatedAt = DateTime.now();
    }

    // Parse ID (bisa berupa int atau string di JSON)
    int parsedId;
    try {
      parsedId = json['id'] is int ? json['id'] : int.parse(json['id'].toString());
    } catch (e) {
      print('Error parsing id: $e');
      parsedId = -1; // Fallback ID
    }

    // Parse userID (bisa berupa int atau string di JSON)
    int parsedUserId;
    try {
      parsedUserId = json['user_id'] is int ? json['user_id'] : int.parse(json['user_id'].toString());
    } catch (e) {
      print('Error parsing user_id: $e');
      parsedUserId = -1; // Fallback user ID
    }

    return ChatbotConversation(
      id: parsedId,
      userId: parsedUserId,
      title: json['title'] ?? 'Untitled Conversation',
      createdAt: parsedCreatedAt,
      updatedAt: parsedUpdatedAt,
      isActive: json['is_active'] ?? true,
      messages: messagesList,
    );
  }

  // Untuk membuat preview singkat pesan terakhir
  String? get lastMessagePreview {
    if (messages == null || messages!.isEmpty) {
      return null;
    }
    
    final lastMsg = messages!.last;
    String preview = lastMsg.content;
    
    // Potong jika terlalu panjang
    if (preview.length > 50) {
      preview = '${preview.substring(0, 47)}...';
    }
    
    return preview;
  }
}