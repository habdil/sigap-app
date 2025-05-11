import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/models/health_assessment_model.dart';

class HealthService {
  static const String baseUrl = 'http://localhost:3000/api';
  
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
          Uri.parse('$baseUrl/assessment'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${user.token}',
          },
          body: jsonEncode(assessment.toJson()),
        ).timeout(const Duration(seconds: 10));

        print('Submit assessment status code: ${response.statusCode}');
        print('Response body: ${response.body}');

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
      print('Submit assessment error: $e');
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
          Uri.parse('$baseUrl/assessment/result'),
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
      print('Get latest result error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}