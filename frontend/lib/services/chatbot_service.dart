// Path: lib/services/chatbot_service.dart
import 'dart:convert';
import 'package:frontend/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/chatbot_conversation.dart';
import 'package:frontend/models/chatbot_message.dart';
import 'package:frontend/services/storage_service.dart';

class ChatbotService {
  // Dapatkan base URL dari konfigurasi
  static String get baseUrl => '${AppConfig.instance.apiBaseUrl}/chatbot';
  static int get timeout => AppConfig.instance.timeout;
  
  // Mendapatkan token autentikasi dari user yang tersimpan
  static Future<String?> _getAuthToken() async {
    final user = await StorageService.getUser();
    if (user == null || user.token == null) {
      return null;
    }
    return user.token;
  }
  
  // Mendapatkan headers untuk request
  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getAuthToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }
    
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Membuat konversasi baru - dengan perbaikan untuk menangani HTTP 201
  static Future<ChatbotConversation> createConversation(String title) async {
    try {
      final headers = await _getHeaders();
      
      final client = http.Client();
      try {
        final response = await client.post(
          Uri.parse('$baseUrl/conversations'),
          headers: headers,
          body: jsonEncode({'title': title}),
        ).timeout(const Duration(seconds: 15));

        print('Create conversation status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        // Menangani kode 200 dan 201 sebagai sukses
        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          return ChatbotConversation.fromJson(data['conversation']);
        } else {
          Map<String, dynamic> errorData = {};
          try {
            errorData = jsonDecode(response.body);
          } catch (e) {
            // Ignore JSON decode errors
          }
          
          throw Exception(errorData['message'] ?? 'Failed to create conversation: ${response.statusCode}');
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Create conversation error: $e');
      throw Exception('Error creating conversation: $e');
    }
  }

  // Mendapatkan semua konversasi
  static Future<List<ChatbotConversation>> getConversations() async {
    try {
      final headers = await _getHeaders();
      
      final client = http.Client();
      try {
        final response = await client.get(
          Uri.parse('$baseUrl/conversations'),
          headers: headers,
        ).timeout(const Duration(seconds: 15));

        print('Get conversations status code: ${response.statusCode}');
        print('Response body: ${response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          final List<dynamic> conversationsJson = data['conversations'];
          return conversationsJson
              .map((json) => ChatbotConversation.fromJson(json))
              .toList();
        } else {
          Map<String, dynamic> errorData = {};
          try {
            errorData = jsonDecode(response.body);
          } catch (e) {
            // Ignore JSON decode errors
          }
          
          throw Exception(errorData['message'] ?? 'Failed to load conversations: ${response.statusCode}');
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Get conversations error: $e');
      throw Exception('Error getting conversations: $e');
    }
  }

  // Mendapatkan detail konversasi dengan pesan-pesan di dalamnya
  static Future<ChatbotConversation> getConversationDetail(int conversationId) async {
    try {
      final headers = await _getHeaders();
      
      final client = http.Client();
      try {
        final response = await client.get(
          Uri.parse('$baseUrl/conversations/$conversationId'),
          headers: headers,
        ).timeout(const Duration(seconds: 15));

        print('Get conversation detail status code: ${response.statusCode}');
        print('Response body: ${response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          return ChatbotConversation.fromJson(data['conversation']);
        } else {
          Map<String, dynamic> errorData = {};
          try {
            errorData = jsonDecode(response.body);
          } catch (e) {
            // Ignore JSON decode errors
          }
          
          throw Exception(errorData['message'] ?? 'Failed to load conversation: ${response.statusCode}');
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Get conversation detail error: $e');
      throw Exception('Error getting conversation detail: $e');
    }
  }

  // Mengirim pesan dan mendapatkan respons dari bot
  static Future<Map<String, ChatbotMessage>> sendMessage(int conversationId, String content) async {
    try {
      final headers = await _getHeaders();
      
      final client = http.Client();
      try {
        final response = await client.post(
          Uri.parse('$baseUrl/conversations/$conversationId/messages'),
          headers: headers,
          body: jsonEncode({'content': content}),
        ).timeout(const Duration(seconds: 20)); // Waktu lebih lama karena bot mungkin memerlukan waktu untuk merespons

        print('Send message status code: ${response.statusCode}');
        print('Response body: ${response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          return {
            'user': ChatbotMessage.fromJson(data['user_message']),
            'bot': ChatbotMessage.fromJson(data['bot_message']),
          };
        } else {
          Map<String, dynamic> errorData = {};
          try {
            errorData = jsonDecode(response.body);
          } catch (e) {
            // Ignore JSON decode errors
          }
          
          throw Exception(errorData['message'] ?? 'Failed to send message: ${response.statusCode}');
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Send message error: $e');
      throw Exception('Error sending message: $e');
    }
  }

  // Mendapatkan semua pesan dalam konversasi
  static Future<List<ChatbotMessage>> getMessages(int conversationId) async {
    try {
      final headers = await _getHeaders();
      
      final client = http.Client();
      try {
        final response = await client.get(
          Uri.parse('$baseUrl/conversations/$conversationId/messages'),
          headers: headers,
        ).timeout(const Duration(seconds: 15));

        print('Get messages status code: ${response.statusCode}');
        print('Response body: ${response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          final List<dynamic> messagesJson = data['messages'];
          return messagesJson
              .map((json) => ChatbotMessage.fromJson(json))
              .toList();
        } else {
          Map<String, dynamic> errorData = {};
          try {
            errorData = jsonDecode(response.body);
          } catch (e) {
            // Ignore JSON decode errors
          }
          
          throw Exception(errorData['message'] ?? 'Failed to load messages: ${response.statusCode}');
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Get messages error: $e');
      throw Exception('Error getting messages: $e');
    }
  }

  // Menghapus konversasi
  static Future<bool> deleteConversation(int conversationId) async {
    try {
      final headers = await _getHeaders();
      
      final client = http.Client();
      try {
        final response = await client.delete(
          Uri.parse('$baseUrl/conversations/$conversationId'),
          headers: headers,
        ).timeout(const Duration(seconds: 15));

        print('Delete conversation status code: ${response.statusCode}');
        print('Response body: ${response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body}');

        return response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204;
      } finally {
        client.close();
      }
    } catch (e) {
      print('Delete conversation error: $e');
      throw Exception('Error deleting conversation: $e');
    }
  }
}