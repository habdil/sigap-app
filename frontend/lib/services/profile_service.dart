import 'dart:convert';
import 'package:frontend/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/user_profile_model.dart';
import 'package:frontend/services/storage_service.dart';

class ProfileService {
  // Dapatkan base URL dari konfigurasi
  static String get baseUrl => AppConfig.instance.apiBaseUrl;
  static int get timeout => AppConfig.instance.timeout; // Replace with your actual API URL
  
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
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}