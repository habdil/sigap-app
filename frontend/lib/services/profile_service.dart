import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/user_profile_model.dart';
import 'package:frontend/services/storage_service.dart';

class ProfileService {
  static const String baseUrl = 'http://192.168.1.17:3000/api';
  
  static Future<Map<String, dynamic>> updateProfile(UserProfile profile) async {
    try {
      final user = await StorageService.getUser();
      if (user == null || user.token == null) {
        return {
          'success': false,
          'message': 'User not authenticated',
        };
      }

      final client = http.Client();
      try {
        final response = await client.put(
          Uri.parse('$baseUrl/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${user.token}',
          },
          body: jsonEncode(profile.toJson()),
        ).timeout(const Duration(seconds: 10));

        print('Update profile status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          return {
            'success': true,
            'data': jsonDecode(response.body),
          };
        } else {
          Map<String, dynamic> errorData = {};
          try {
            errorData = jsonDecode(response.body);
          } catch (e) {
            // Ignore JSON decode errors
          }
          
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to update profile',
          };
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Update profile error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final user = await StorageService.getUser();
      if (user == null || user.token == null) {
        return {
          'success': false,
          'message': 'User not authenticated',
        };
      }

      final client = http.Client();
      try {
        final response = await client.get(
          Uri.parse('$baseUrl/profile'),
          headers: {
            'Authorization': 'Bearer ${user.token}',
          },
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          return {
            'success': true,
            'data': UserProfile.fromJson(jsonDecode(response.body)),
          };
        } else {
          Map<String, dynamic> errorData = {};
          try {
            errorData = jsonDecode(response.body);
          } catch (e) {
            // Ignore JSON decode errors
          }
          
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to get profile',
          };
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Get profile error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}