// Path: lib/models/chatbot_message.dart

class ChatbotMessage {
  final int id;
  final int conversationId;
  final int userId;
  final String content;
  final String senderType; // "user" atau "bot"
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  ChatbotMessage({
    required this.id,
    required this.conversationId,
    required this.userId,
    required this.content,
    required this.senderType,
    required this.createdAt,
    this.metadata,
  });

  bool get isUser => senderType == 'user';

  // Factory method untuk konversi dari JSON ke model dengan penanganan yang lebih robust
  factory ChatbotMessage.fromJson(Map<String, dynamic> json) {
    // Log untuk debugging
    print('Parsing message: ${json.keys}');
    
    // Parse ID (bisa berupa int atau string di JSON)
    int parsedId;
    try {
      parsedId = json['id'] is int ? json['id'] : int.parse(json['id'].toString());
    } catch (e) {
      print('Error parsing message id: $e');
      parsedId = -1; // Fallback ID
    }

    // Parse conversationId (bisa berupa int atau string di JSON)
    int parsedConversationId;
    try {
      parsedConversationId = json['conversation_id'] is int 
          ? json['conversation_id'] 
          : int.parse(json['conversation_id'].toString());
    } catch (e) {
      print('Error parsing conversation_id: $e');
      parsedConversationId = -1; // Fallback conversation ID
    }

    // Parse userId (bisa berupa int atau string di JSON)
    int parsedUserId;
    try {
      parsedUserId = json['user_id'] is int 
          ? json['user_id'] 
          : int.parse(json['user_id'].toString());
    } catch (e) {
      print('Error parsing user_id: $e');
      parsedUserId = -1; // Fallback user ID
    }

    // Parse tanggal
    DateTime parsedCreatedAt;
    try {
      parsedCreatedAt = DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String());
    } catch (e) {
      print('Error parsing created_at: $e');
      parsedCreatedAt = DateTime.now();
    }

    return ChatbotMessage(
      id: parsedId,
      conversationId: parsedConversationId,
      userId: parsedUserId,
      content: json['content'] ?? '',
      senderType: json['sender_type'] ?? 'bot',
      createdAt: parsedCreatedAt,
      metadata: json['metadata'],
    );
  }

  // Konversi model ke format yang diperlukan oleh UI
  Map<String, dynamic> toUiFormat() {
    return {
      'id': id.toString(),
      'text': content,
      'isUser': isUser,
      'showActions': !isUser,
      'timestamp': createdAt.toIso8601String(),
    };
  }
}