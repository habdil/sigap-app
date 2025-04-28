import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Base URL of your API
  static const String baseUrl = 'http://192.168.170.136:3000/api/auth';

  // Signup method
  static Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting to connect to: $baseUrl/signup');

      final client = http.Client();
      try {
        final response = await client
            .post(
              Uri.parse('$baseUrl/signup'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                'username': username,
                'email': email,
                'password': password,
              }),
            )
            .timeout(const Duration(seconds: 15));

        print('Response status code: ${response.statusCode}');
        print(
            'Response body: ${response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body}');

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
              'message': responseData['message'] ??
                  responseData['error'] ??
                  'Failed to sign up. Status code: ${response.statusCode}',
            };
          }
        } catch (parseError) {
          // If JSON parsing fails, return the error with response details
          return {
            'success': false,
            'message':
                'Server returned invalid format. Status code: ${response.statusCode}',
            'details': response.body.length > 100
                ? response.body.substring(0, 100) + '...'
                : response.body,
          };
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Signup error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Login method
  static Future<Map<String, dynamic>> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      print('Attempting to connect to: $baseUrl/login');

      final client = http.Client();
      try {
        // Coba beberapa format payload untuk login
        final List<Map<String, dynamic>> payloadsToTry = [
          {
            'usernameOrEmail': usernameOrEmail,
            'password': password,
          },
          {
            'email': usernameOrEmail,
            'password': password,
          },
          {
            'Email': usernameOrEmail,
            'Password': password,
          },
          {
            'username': usernameOrEmail,
            'password': password,
          }
        ];

        Map<String, dynamic>? successResponse;
        String lastErrorMessage = '';
        int lastStatusCode = 0;

        // Coba setiap format payload
        for (final payload in payloadsToTry) {
          print('Trying login with payload: $payload');

          try {
            final response = await client
                .post(
                  Uri.parse('$baseUrl/login'),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode(payload),
                )
                .timeout(const Duration(seconds: 10));

            print('Response status code: ${response.statusCode}');
            print(
                'Response body: ${response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body}');

            try {
              final Map<String, dynamic> responseData =
                  jsonDecode(response.body);

              if (response.statusCode == 200) {
                successResponse = {
                  'success': true,
                  'data': responseData,
                };
                break; // Format berhasil, keluar dari loop
              } else {
                lastErrorMessage = responseData['message'] ??
                    responseData['error'] ??
                    'Failed to login. Status code: ${response.statusCode}';
                lastStatusCode = response.statusCode;
              }
            } catch (parseError) {
              lastErrorMessage =
                  'Server returned invalid format. Status code: ${response.statusCode}';
              lastStatusCode = response.statusCode;
            }
          } catch (e) {
            print('Error trying payload $payload: $e');
            // Lanjutkan ke payload berikutnya
          }
        }

        // Jika ada respons sukses, kembalikan
        if (successResponse != null) {
          return successResponse;
        }

        // Jika semua format gagal, kembalikan error terakhir
        return {
          'success': false,
          'message': lastErrorMessage.isNotEmpty
              ? lastErrorMessage
              : 'Failed to login with all payload formats. Last status code: $lastStatusCode',
        };
      } finally {
        client.close();
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Test connection method
  static Future<bool> testConnection() async {
    try {
      final client = http.Client();
      try {
        // First try the base URL
        print('Testing connection to: $baseUrl');
        final response = await client
            .get(
              Uri.parse(baseUrl),
            )
            .timeout(const Duration(seconds: 5));

        print('Base URL response: ${response.statusCode}');
        return response.statusCode <
            500; // Consider any non-server error as "connected"
      } catch (e) {
        // If base URL fails, try the server root
        try {
          print('Testing connection to server root');
          final rootUrl = Uri.parse(baseUrl).replace(path: '');
          final rootResponse =
              await client.get(rootUrl).timeout(const Duration(seconds: 5));

          print('Root URL response: ${rootResponse.statusCode}');
          return rootResponse.statusCode < 500;
        } catch (e) {
          print('Both connection tests failed: $e');
          return false;
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Test connection error: $e');
      return false;
    }
  }
}
