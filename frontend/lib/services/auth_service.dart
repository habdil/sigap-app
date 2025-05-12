import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Base URL of your API
  static const String baseUrl = 'http://192.168.1.17:3000/api/auth'; // Replace with your actual API URL
  
  // Signup method
  static Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting to connect to: $baseUrl/signup');
      
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 15));
      
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body}');
      
      // Try to parse as JSON first
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          return {
            'success': true,
            'data': responseData,
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? responseData['error'] ?? 'Failed to sign up. Status code: ${response.statusCode}',
          };
        }
      } catch (parseError) {
        // If JSON parsing fails, return the error with response details
        return {
          'success': false,
          'message': 'Server returned invalid format. Status code: ${response.statusCode}',
          'details': response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body,
        };
      }
    } catch (e) {
      print('Signup error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
  
  // Metode login dengan penanganan respons yang lebih baik
  static Future<Map<String, dynamic>> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      print('Attempting to connect to: $baseUrl/login');
      
      final payload = {
        'email': usernameOrEmail,
        'password': password,
      };
      
      print('Sending login payload: $payload');
      
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 15));
      
      print('Response status code: ${response.statusCode}');
      print('Response full body: ${response.body}'); // Print full response for debugging
      
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Parsed response data: $responseData'); // Print parsed data for debugging
        
        if (response.statusCode == 200) {
          // Deteksi format respons dan standarisasi ke format umum yang diharapkan frontend
          final standardizedData = _standardizeLoginResponse(responseData);
          
          if (standardizedData['success']) {
            return {
              'success': true,
              'data': standardizedData['data'],
            };
          } else {
            return {
              'success': false,
              'message': standardizedData['message'],
            };
          }
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? responseData['error'] ?? 'Failed to login. Status code: ${response.statusCode}',
          };
        }
      } catch (parseError) {
        print('JSON parsing error: $parseError');
        return {
          'success': false,
          'message': 'Server returned invalid format. Status code: ${response.statusCode}',
          'details': response.body,
        };
      }
    } catch (e) {
      print('Login network error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

    // Helper function untuk standardisasi format respons
  static Map<String, dynamic> _standardizeLoginResponse(Map<String, dynamic> rawResponse) {
    try {
      // Format 1: Respons langsung memiliki semua field yang dibutuhkan
      if (rawResponse.containsKey('id') && rawResponse.containsKey('token')) {
        return {
          'success': true,
          'data': {
            'id': rawResponse['id'],
            'username': rawResponse['username'] ?? '',
            'email': rawResponse['email'] ?? '',
            'token': rawResponse['token'],
          },
        };
      }
      
      // Format 2: Respons memiliki 'user' object dan 'token' terpisah
      else if (rawResponse.containsKey('user') && rawResponse.containsKey('token')) {
        final userData = rawResponse['user'];
        
        if (userData is Map<String, dynamic>) {
          return {
            'success': true,
            'data': {
              'id': userData['id'],
              'username': userData['username'] ?? '',
              'email': userData['email'] ?? '',
              'token': rawResponse['token'],
            },
          };
        }
      }
      
      // Format 3: Respons memiliki 'data' yang berisi user info
      else if (rawResponse.containsKey('data')) {
        final userData = rawResponse['data'];
        
        if (userData is Map<String, dynamic>) {
          return {
            'success': true,
            'data': {
              'id': userData['id'] ?? 0,
              'username': userData['username'] ?? '',
              'email': userData['email'] ?? '',
              'token': userData['token'] ?? rawResponse['token'] ?? '',
            },
          };
        }
      }
      
      // Format tidak dikenali
      print('Unrecognized response format: $rawResponse');
      return {
        'success': false,
        'message': 'Unrecognized response format from server',
      };
    } catch (e) {
      print('Error standardizing response: $e');
      return {
        'success': false,
        'message': 'Error processing server response: ${e.toString()}',
      };
    }
  }
  
  // Test connection method
  static Future<bool> testConnection() async {
    try {
      print('Testing connection to: $baseUrl');
      final response = await http.get(
        Uri.parse(baseUrl),
      ).timeout(const Duration(seconds: 5));
      
      print('Base URL response: ${response.statusCode}');
      return response.statusCode < 500; // Consider any non-server error as "connected"
    } catch (e) {
      // If base URL fails, try the server root
      try {
        print('Testing connection to server root');
        final rootUrl = Uri.parse(baseUrl).replace(path: '');
        final rootResponse = await http.get(rootUrl)
            .timeout(const Duration(seconds: 5));
        
        print('Root URL response: ${rootResponse.statusCode}');
        return rootResponse.statusCode < 500;
      } catch (e) {
        print('Both connection tests failed: $e');
        return false;
      }
    }
  }
}