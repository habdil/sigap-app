// Path: lib/providers/chatbot_provider.dart
import 'package:flutter/material.dart';
import 'package:frontend/models/chatbot_conversation.dart';
import 'package:frontend/models/chatbot_message.dart';
import 'package:frontend/services/chatbot_service.dart';

class ChatbotProvider extends ChangeNotifier {
  // Current conversation
  ChatbotConversation? _currentConversation;
  List<ChatbotMessage> _messages = [];
  bool _isLoading = false;
  String? _error;
  
  // Getter
  ChatbotConversation? get currentConversation => _currentConversation;
  List<ChatbotMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get messagesUiFormat => 
      _messages.map((msg) => msg.toUiFormat()).toList();
      
  // Mendapatkan semua konversasi
  Future<List<ChatbotConversation>> getConversations() async {
    _setLoading(true);
    try {
      final conversations = await ChatbotService.getConversations();
      _setLoading(false);
      return conversations;
    } catch (e) {
      _setError('Failed to load conversations: $e');
      _setLoading(false);
      return [];
    }
  }

  // Membuat konversasi baru
  Future<void> createNewConversation(String title) async {
    _setLoading(true);
    try {
      final conversation = await ChatbotService.createConversation(title);
      _currentConversation = conversation;
      _loadMessages(conversation.id);
    } catch (e) {
      _setError('Failed to create conversation: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Mendapatkan detail konversasi yang sudah ada
  Future<void> loadConversation(int conversationId) async {
    _setLoading(true);
    try {
      final conversation = await ChatbotService.getConversationDetail(conversationId);
      _currentConversation = conversation;
      if (conversation.messages != null) {
        _messages = conversation.messages!;
      } else {
        await _loadMessages(conversationId);
      }
    } catch (e) {
      _setError('Failed to load conversation: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Memuat pesan-pesan dalam konversasi
  Future<void> _loadMessages(int conversationId) async {
    try {
      final messages = await ChatbotService.getMessages(conversationId);
      _messages = messages;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load messages: $e');
    }
  }

  // Mengirim pesan ke chatbot
  Future<void> sendMessage(String content) async {
    if (_currentConversation == null) {
      // Jika belum ada konversasi, buat baru
      await createNewConversation('New Conversation');
      if (_currentConversation == null) {
        return; // Failed to create conversation
      }
    }

    _setLoading(true);
    
    try {
      // Tambahkan pesan pengguna ke UI sebelum mengirim ke server
      // untuk UX yang lebih baik
      final tempUserMsg = ChatbotMessage(
        id: -1, // Temporary ID
        conversationId: _currentConversation!.id,
        userId: _currentConversation!.userId,
        content: content,
        senderType: 'user',
        createdAt: DateTime.now(),
      );
      
      _messages.add(tempUserMsg);
      notifyListeners();
      
      // Kirim ke server
      final response = await ChatbotService.sendMessage(_currentConversation!.id, content);
      
      // Update pesan pengguna dengan versi dari server dan tambahkan respons bot
      final userIndex = _messages.indexWhere((msg) => 
          msg.id == -1 && msg.content == content);
      
      if (userIndex != -1) {
        _messages[userIndex] = response['user']!;
      }
      
      _messages.add(response['bot']!);
    } catch (e) {
      _setError('Failed to send message: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Menghapus konversasi
  Future<bool> deleteConversation(int conversationId) async {
    _setLoading(true);
    try {
      final result = await ChatbotService.deleteConversation(conversationId);
      if (result && _currentConversation?.id == conversationId) {
        _currentConversation = null;
        _messages = [];
      }
      return result;
    } catch (e) {
      _setError('Failed to delete conversation: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper untuk status loading
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Helper untuk error handling
  void _setError(String errorMessage) {
    _error = errorMessage;
    print(errorMessage); // For debugging
    notifyListeners();
  }

  // Reset error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}