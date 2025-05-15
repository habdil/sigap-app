// lib/services/activity_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:frontend/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/models/activity_model.dart';

class ActivityService {
  // Dapatkan base URL dari konfigurasi
  static String get baseUrl => '${AppConfig.instance.apiBaseUrl}/activites';
  
  // Timeout untuk request
  static int get timeout => AppConfig.instance.timeout;
  
  // Method untuk menambah aktivitas baru
  static Future<Map<String, dynamic>> addActivity(ActivityModel activity) async {
    try {
      print('ActivityService: Starting addActivity for ${activity.activityType}');
      final user = await StorageService.getUser();
      if (user == null || user.token == null) {
        print('ActivityService: User not authenticated in addActivity');
        return {
          'success': false,
          'message': 'User not authenticated',
        };
      }

      final client = http.Client();
      try {
        print('ActivityService: Sending activity data: ${jsonEncode(activity.toJson())}');
        
        final response = await client.post(
          Uri.parse(baseUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${user.token}',
          },
          body: jsonEncode(activity.toJson()),
        ).timeout(Duration(seconds: timeout));

        print('ActivityService: Add activity response status: ${response.statusCode}');
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          print('ActivityService: Successfully added activity');
          return {
            'success': true,
            'data': ActivityModel.fromJson(responseData),
          };
        } else {
          Map<String, dynamic> errorData = {};
          try {
            if (response.body.isNotEmpty) {
              errorData = jsonDecode(response.body);
              print('ActivityService: Error response body: ${response.body}');
            }
          } catch (e) {
            print('ActivityService: Error parsing error response: $e');
          }
          
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to add activity (Status: ${response.statusCode})',
          };
        }
      } on TimeoutException {
        print('ActivityService: Request timed out during add activity');
        return {
          'success': false,
          'message': 'Request timed out. Please check your network connection and try again.',
        };
      } catch (e) {
        print('ActivityService: Network error in addActivity: $e');
        return {
          'success': false,
          'message': 'Network error: ${e.toString()}',
        };
      } finally {
        client.close();
      }
    } catch (e) {
      print('ActivityService: General error in addActivity: $e');
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

static Future<Map<String, dynamic>> getActivities() async {
  try {
    print('ActivityService: Getting activities');
    final user = await StorageService.getUser();
    if (user == null || user.token == null) {
      print('ActivityService: User not authenticated in getActivities');
      return {
        'success': false,
        'message': 'User not authenticated',
      };
    }

    final client = http.Client();
    try {
      final String fetchUrl = AppConfig.instance.apiBaseUrl + '/activities';
      print('ActivityService: Requesting activities from API: $fetchUrl');
      
      final response = await client.get(
        Uri.parse(fetchUrl),
        headers: {
          'Authorization': 'Bearer ${user.token}',
        },
      ).timeout(Duration(seconds: timeout));

      print('ActivityService: Activities response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        // Tangani respons kosong atau null
        if (response.body.isEmpty) {
          print('ActivityService: Received empty response body for activities');
          return {
            'success': true,
            'data': <ActivityModel>[],
          };
        }
        
        try {
          final dynamic responseData = jsonDecode(response.body);
          
          // Perbaikan: Cek jika responseData adalah null atau bukan List
          if (responseData == null) {
            print('ActivityService: Response data is null, returning empty list');
            return {
              'success': true,
              'data': <ActivityModel>[],
            };
          }
          
          if (responseData is! List) {
            print('ActivityService: Response data is not a list, returning empty list');
            print('ActivityService: Response data type: ${responseData.runtimeType}');
            return {
              'success': true,
              'data': <ActivityModel>[],
            };
          }
          
          final List<dynamic> activityList = responseData;
          final List<ActivityModel> activities = activityList
              .map((json) => ActivityModel.fromJson(json))
              .toList();
          
          print('ActivityService: Successfully parsed ${activities.length} activities');
          return {
            'success': true,
            'data': activities,
          };
        } catch (e) {
          print('ActivityService: Error parsing activities: $e');
          if (response.body.isNotEmpty) {
            print('ActivityService: Response body prefix: ${response.body.substring(0, min(100, response.body.length))}');
          } else {
            print('ActivityService: Response body is empty');
          }
          
          // Perbaikan: Return empty list pada kasus parsing error
          return {
            'success': true,
            'data': <ActivityModel>[],
            'message': 'No activities found or data format is incorrect',
          };
        }
      } else {
        Map<String, dynamic> errorData = {};
        try {
          if (response.body.isNotEmpty) {
            errorData = jsonDecode(response.body);
            print('ActivityService: Error response body: ${response.body}');
          }
        } catch (e) {
          print('ActivityService: Error parsing error response: $e');
        }
        
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to get activities (Status: ${response.statusCode})',
        };
      }
    } on TimeoutException {
      print('ActivityService: Request timed out during get activities');
      return {
        'success': false,
        'message': 'Request timed out. Please check your network connection and try again.',
      };
    } catch (e) {
      print('ActivityService: Network error in getActivities: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    } finally {
      client.close();
    }
  } catch (e) {
    print('ActivityService: General error in getActivities: $e');
    return {
      'success': false,
      'message': 'Error: ${e.toString()}',
    };
  }
}

  // Helper function untuk membatasi string length
  static int min(int a, int b) {
    return a < b ? a : b;
  }
}