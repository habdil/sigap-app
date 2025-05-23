import 'dart:convert';
import 'package:frontend/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/models/health_assessment_model.dart';

class HealthService {
  // Dapatkan base URL dari konfigurasi
  static String get baseUrl => '${AppConfig.instance.apiBaseUrl}/assessment';
  static int get timeout => AppConfig.instance.timeout;
  
  // Method baru untuk mengecek status assessment
  static Future<Map<String, dynamic>> checkAssessmentStatus() async {
    try {
      final user = await StorageService.getUser();
      if (user == null || user.token == null) {
        return {
          'success': false,
          'message': 'User not authenticated',
          'needsAssessment': true, // Default ke true jika user belum login
        };
      }

      final client = http.Client();
      try {
        final response = await client.get(
          Uri.parse('$baseUrl/status'),
          headers: {
            'Authorization': 'Bearer ${user.token}',
          },
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          return {
            'success': true,
            'needsAssessment': responseData['needs_assessment'] ?? true,
          };
        } else {
          Map<String, dynamic> errorData = {};
            errorData = jsonDecode(response.body);
          
          return {
            'success': false,
            'message': errorData['error'] ?? 'Failed to check assessment status',
            'needsAssessment': true, // Default ke true jika ada error
          };
        }
      } finally {
        client.close();
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
        'needsAssessment': true, // Default ke true jika ada error
      };
    }
  }
  
  static Future<Map<String, dynamic>> submitAssessment(HealthAssessment assessment) async {
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
        final response = await client.post(
          Uri.parse(baseUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${user.token}',
          },
          body: jsonEncode(assessment.toJson()),
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200 || response.statusCode == 201) {
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
            'message': errorData['message'] ?? 'Failed to submit assessment',
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

  static Future<Map<String, dynamic>> getLatestResult() async {
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
          Uri.parse('$baseUrl/latest'),  // Perhatikan endpoint yang benar: /latest, bukan /result
          headers: {
            'Authorization': 'Bearer ${user.token}',
          },
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
            'message': errorData['message'] ?? 'Failed to get latest result',
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