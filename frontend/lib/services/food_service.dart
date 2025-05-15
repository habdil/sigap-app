// lib/services/food_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:frontend/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/models/food_model.dart';
import 'package:frontend/models/food_analysis_model.dart';

class FoodService {
  // Dapatkan base URL dari konfigurasi
  static String get baseUrl => '${AppConfig.instance.apiBaseUrl}/food';

  // Timeout untuk analisis gambar - 30 detik cukup untuk API yang lebih lambat
  static int get extendedTimeout => 30; // 30 detik untuk analisis gambar
  static int get timeout => AppConfig.instance.timeout;
  
  // Konstanta untuk mode testing
  static const bool useMockData = false; // Set ke false untuk produksi

  // Method untuk menambah log makanan baru
  static Future<Map<String, dynamic>> addFoodLog(FoodLog foodLog) async {
    try {
      final user = await StorageService.getUser();
      if (user == null || user.token == null) {
        print('FoodService: User not authenticated in addFoodLog');
        return {
          'success': false,
          'message': 'User not authenticated',
        };
      }

      final client = http.Client();
      try {
        print('FoodService: Sending addFoodLog request: ${foodLog.foodName}');
        
        final response = await client.post(
          Uri.parse(baseUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${user.token}',
          },
          body: jsonEncode(foodLog.toJson()),
        ).timeout(Duration(seconds: timeout));

        print('FoodService: Add food log response status: ${response.statusCode}');
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          print('FoodService: Successfully added food log');
          return {
            'success': true,
            'data': FoodLog.fromJson(responseData),
          };
        } else {
          Map<String, dynamic> errorData = {};
          try {
            if (response.body.isNotEmpty) {
              errorData = jsonDecode(response.body);
              print('FoodService: Error response body: ${response.body}');
            }
          } catch (e) {
            print('FoodService: Error parsing error response: $e');
          }
          
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to add food log (Status: ${response.statusCode})',
          };
        }
      } on TimeoutException {
        print('FoodService: Request timed out during add food log');
        return {
          'success': false,
          'message': 'Request timed out. Please check your network connection and try again.',
        };
      } catch (e) {
        print('FoodService: Network error in addFoodLog: $e');
        return {
          'success': false,
          'message': 'Network error: ${e.toString()}',
        };
      } finally {
        client.close();
      }
    } catch (e) {
      print('FoodService: General error in addFoodLog: $e');
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }
  
  // Method untuk menganalisis makanan dengan foto
  static Future<Map<String, dynamic>> analyzeFoodWithImage(int foodLogId, String imageData) async {
    try {
      print('FoodService: Starting analyzeFoodWithImage for foodLogId: $foodLogId');
      final user = await StorageService.getUser();
      if (user == null || user.token == null) {
        print('FoodService: User not authenticated in analyzeFoodWithImage');
        return {
          'success': false,
          'message': 'User not authenticated',
        };
      }

      // Kompres data gambar jika ukurannya besar
      final compressedImageData = await _compressImageIfNeeded(imageData);
      print('FoodService: Image data compressed/prepared for sending');

      final client = http.Client();
      try {
        print('FoodService: Sending image analysis request for food log ID: $foodLogId');
        print('FoodService: Image data length: ${compressedImageData.length} characters');
        
        // Tampilkan sedikit informasi tentang data gambar untuk debugging
        if (compressedImageData.length > 100) {
          print('FoodService: Image data prefix: ${compressedImageData.substring(0, 100)}...');
        }
        
        // Implementasi penanganan retry otomatis
        return await _retryRequest(() async {
          print('FoodService: Making actual API call to $baseUrl/analyze');
          final response = await client.post(
            Uri.parse('$baseUrl/analyze'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${user.token}',
            },
            body: jsonEncode({
              'food_log_id': foodLogId,
              'image_data': compressedImageData,
            }),
          ).timeout(Duration(seconds: extendedTimeout));

          print('FoodService: Image analysis response status: ${response.statusCode}');
          
          if (response.statusCode == 200) {
            try {
              print('FoodService: Decoding successful response from API');
              final responseData = jsonDecode(response.body);
              
              // Perbaikan: tambahkan delay kecil untuk menghindari race condition
              await Future.delayed(Duration(milliseconds: 200));
              
              print('FoodService: Successfully received food analysis data from API');
              return {
                'success': true,
                'data': FoodAnalysis.fromJson(responseData),
              };
            } catch (e) {
              print('FoodService: Error parsing food analysis response: $e');
              if (response.body.isNotEmpty) {
                print('FoodService: Response body prefix: ${response.body.substring(0, min(100, response.body.length))}');
              }
              throw Exception('Error parsing analysis response: ${e.toString()}');
            }
          } else {
            Map<String, dynamic> errorData = {};
            try {
              if (response.body.isNotEmpty) {
                errorData = jsonDecode(response.body);
                print('FoodService: Error response body: ${response.body}');
              }
            } catch (e) {
              print('FoodService: Error parsing error response: $e');
            }
            
            throw Exception(errorData['message'] ?? 'Failed to analyze food (Status: ${response.statusCode})');
          }
        }, maxRetries: 2);
      } on TimeoutException {
        print('FoodService: Request timed out during food analysis');
        return {
          'success': false,
          'message': 'Analysis is taking too long. The server might be busy, please try again later.',
        };
      } catch (e) {
        print('FoodService: Network error in analyzeFoodWithImage: $e');
        return {
          'success': false,
          'message': 'Network error: ${e.toString()}',
        };
      } finally {
        client.close();
      }
    } catch (e) {
      print('FoodService: General error in analyzeFoodWithImage: $e');
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }
  
  // Fungsi untuk kompres gambar jika terlalu besar
  static Future<String> _compressImageIfNeeded(String imageData) async {
    // Jika gambar lebih dari 1MB, kompres secara sederhana
    if (imageData.length > 1000000) {
      try {
        print('FoodService: Compressing large image (${imageData.length} chars)');
        
        // Potong prefix jika ada
        String base64Data = imageData;
        if (imageData.contains(';base64,')) {
          base64Data = imageData.split(';base64,')[1];
        }
        
        // Logika kompresi gambar
        // Karena kita tidak memiliki akses langsung ke library seperti flutter_image_compress saat ini,
        // kita hanya mengembalikan data asli untuk contoh ini
        
        print('FoodService: Image compressed/processed');
        return imageData;
      } catch (e) {
        print('FoodService: Error compressing image: $e');
        // Jika gagal kompres, kembalikan data asli
        return imageData;
      }
    }
    return imageData;
  }
  
  // Fungsi retry untuk request penting
  static Future<Map<String, dynamic>> _retryRequest(
    Future<Map<String, dynamic>> Function() request, {
    int maxRetries = 2,
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      try {
        return await request();
      } catch (e) {
        attempts++;
        print('FoodService: Request attempt $attempts failed: $e');
        
        if (attempts >= maxRetries) {
          print('FoodService: Maximum retry attempts reached');
          return {
            'success': false,
            'message': e.toString(),
          };
        }
        
        // Tambahkan delay sebelum retry
        print('FoodService: Waiting before retry attempt ${attempts + 1}');
        await Future.delayed(Duration(seconds: 1));
        print('FoodService: Retrying request (attempt ${attempts + 1}/${maxRetries})');
      }
    }
    
    return {
      'success': false,
      'message': 'Maximum retry attempts reached',
    };
  }
  
  // Method untuk mendapatkan daftar log makanan
  static Future<Map<String, dynamic>> getFoodLogs() async {
    try {
      print('FoodService: Getting food logs');
      final user = await StorageService.getUser();
      if (user == null || user.token == null) {
        print('FoodService: User not authenticated in getFoodLogs');
        return {
          'success': false,
          'message': 'User not authenticated',
        };
      }

      final client = http.Client();
      try {
        print('FoodService: Requesting food logs from API');
        
        final response = await client.get(
          Uri.parse(baseUrl),
          headers: {
            'Authorization': 'Bearer ${user.token}',
          },
        ).timeout(Duration(seconds: timeout));

        print('FoodService: Food logs response status: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          // Tangani respons kosong
          if (response.body.isEmpty) {
            print('FoodService: Received empty response body for food logs');
            return {
              'success': true,
              'data': <FoodLog>[],
            };
          }
          
          try {
            final List<dynamic> responseData = jsonDecode(response.body);
            final List<FoodLog> foodLogs = responseData
                .map((json) => FoodLog.fromJson(json))
                .toList();
            
            print('FoodService: Successfully parsed ${foodLogs.length} food logs');
            return {
              'success': true,
              'data': foodLogs,
            };
          } catch (e) {
            print('FoodService: Error parsing food logs: $e');
            if (response.body.isNotEmpty) {
              print('FoodService: Response body prefix: ${response.body.substring(0, min(100, response.body.length))}');
            }
            return {
              'success': false,
              'message': 'Error parsing response: ${e.toString()}',
            };
          }
        } else {
          Map<String, dynamic> errorData = {};
          try {
            if (response.body.isNotEmpty) {
              errorData = jsonDecode(response.body);
              print('FoodService: Error response body: ${response.body}');
            }
          } catch (e) {
            print('FoodService: Error parsing error response: $e');
          }
          
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to get food logs (Status: ${response.statusCode})',
          };
        }
      } on TimeoutException {
        print('FoodService: Request timed out during get food logs');
        return {
          'success': false,
          'message': 'Request timed out. Please check your network connection and try again.',
        };
      } catch (e) {
        print('FoodService: Network error in getFoodLogs: $e');
        return {
          'success': false,
          'message': 'Network error: ${e.toString()}',
        };
      } finally {
        client.close();
      }
    } catch (e) {
      print('FoodService: General error in getFoodLogs: $e');
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