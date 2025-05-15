// lib/services/coin_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:frontend/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/models/coin_model.dart';
import 'package:frontend/models/coin_transaction_model.dart';

class CoinService {
  // Dapatkan base URL dari konfigurasi
  static String get baseUrl => '${AppConfig.instance.apiBaseUrl}/coins';
  
  // Timeout untuk request
  static int get timeout => AppConfig.instance.timeout;
  
  // Method untuk mendapatkan saldo koin pengguna
  static Future<Map<String, dynamic>> getCoins() async {
    try {
      print('CoinService: Getting user coins');
      final user = await StorageService.getUser();
      if (user == null || user.token == null) {
        print('CoinService: User not authenticated in getCoins');
        return {
          'success': false,
          'message': 'User not authenticated',
        };
      }

      final client = http.Client();
      try {
        print('CoinService: Requesting user coins from API');
        
        final response = await client.get(
          Uri.parse(baseUrl),
          headers: {
            'Authorization': 'Bearer ${user.token}',
          },
        ).timeout(Duration(seconds: timeout));

        print('CoinService: Coins response status: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          // Tangani respons kosong
          if (response.body.isEmpty) {
            print('CoinService: Received empty response body for coins');
            return {
              'success': false,
              'message': 'Empty response from server',
            };
          }
          
          try {
            final responseData = jsonDecode(response.body);
            final coinData = CoinModel.fromJson(responseData);
            
            print('CoinService: Successfully parsed coins data: ${coinData.totalCoins} coins');
            return {
              'success': true,
              'data': coinData,
            };
          } catch (e) {
            print('CoinService: Error parsing coins data: $e');
            if (response.body.isNotEmpty) {
              print('CoinService: Response body: ${response.body}');
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
              print('CoinService: Error response body: ${response.body}');
            }
          } catch (e) {
            print('CoinService: Error parsing error response: $e');
          }
          
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to get coins (Status: ${response.statusCode})',
          };
        }
      } on TimeoutException {
        print('CoinService: Request timed out during get coins');
        return {
          'success': false,
          'message': 'Request timed out. Please check your network connection and try again.',
        };
      } catch (e) {
        print('CoinService: Network error in getCoins: $e');
        return {
          'success': false,
          'message': 'Network error: ${e.toString()}',
        };
      } finally {
        client.close();
      }
    } catch (e) {
      print('CoinService: General error in getCoins: $e');
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  // Method untuk menghabiskan koin
  static Future<Map<String, dynamic>> spendCoins(CoinTransactionModel transaction) async {
    try {
      print('CoinService: Starting spendCoins for amount: ${transaction.amount}');
      final user = await StorageService.getUser();
      if (user == null || user.token == null) {
        print('CoinService: User not authenticated in spendCoins');
        return {
          'success': false,
          'message': 'User not authenticated',
        };
      }

      final client = http.Client();
      try {
        print('CoinService: Sending spend coins request: ${jsonEncode(transaction.toJson())}');
        
        final response = await client.post(
          Uri.parse('$baseUrl/spend'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${user.token}',
          },
          body: jsonEncode(transaction.toJson()),
        ).timeout(Duration(seconds: timeout));

        print('CoinService: Spend coins response status: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          print('CoinService: Successfully spent coins: ${responseData['message']}');
          return {
            'success': true,
            'message': responseData['message'] ?? 'Coins spent successfully',
          };
        } else {
          Map<String, dynamic> errorData = {};
          try {
            if (response.body.isNotEmpty) {
              errorData = jsonDecode(response.body);
              print('CoinService: Error response body: ${response.body}');
            }
          } catch (e) {
            print('CoinService: Error parsing error response: $e');
          }
          
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to spend coins (Status: ${response.statusCode})',
          };
        }
      } on TimeoutException {
        print('CoinService: Request timed out during spend coins');
        return {
          'success': false,
          'message': 'Request timed out. Please check your network connection and try again.',
        };
      } catch (e) {
        print('CoinService: Network error in spendCoins: $e');
        return {
          'success': false,
          'message': 'Network error: ${e.toString()}',
        };
      } finally {
        client.close();
      }
    } catch (e) {
      print('CoinService: General error in spendCoins: $e');
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  // Method untuk mendapatkan riwayat transaksi koin
  static Future<Map<String, dynamic>> getTransactions() async {
    try {
      print('CoinService: Getting coin transactions');
      final user = await StorageService.getUser();
      if (user == null || user.token == null) {
        print('CoinService: User not authenticated in getTransactions');
        return {
          'success': false,
          'message': 'User not authenticated',
        };
      }

      final client = http.Client();
      try {
        print('CoinService: Requesting coin transactions from API');
        
        final response = await client.get(
          Uri.parse('$baseUrl/transactions'),
          headers: {
            'Authorization': 'Bearer ${user.token}',
          },
        ).timeout(Duration(seconds: timeout));

        print('CoinService: Transactions response status: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          // Tangani respons kosong
          if (response.body.isEmpty) {
            print('CoinService: Received empty response body for transactions');
            return {
              'success': true,
              'data': <CoinTransactionModel>[],
            };
          }
          
          try {
            final List<dynamic> responseData = jsonDecode(response.body);
            final List<CoinTransactionModel> transactions = responseData
                .map((json) => CoinTransactionModel.fromJson(json))
                .toList();
            
            print('CoinService: Successfully parsed ${transactions.length} transactions');
            return {
              'success': true,
              'data': transactions,
            };
          } catch (e) {
            print('CoinService: Error parsing transactions: $e');
            if (response.body.isNotEmpty) {
              print('CoinService: Response body prefix: ${response.body.substring(0, min(100, response.body.length))}');
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
              print('CoinService: Error response body: ${response.body}');
            }
          } catch (e) {
            print('CoinService: Error parsing error response: $e');
          }
          
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to get transactions (Status: ${response.statusCode})',
          };
        }
      } on TimeoutException {
        print('CoinService: Request timed out during get transactions');
        return {
          'success': false,
          'message': 'Request timed out. Please check your network connection and try again.',
        };
      } catch (e) {
        print('CoinService: Network error in getTransactions: $e');
        return {
          'success': false,
          'message': 'Network error: ${e.toString()}',
        };
      } finally {
        client.close();
      }
    } catch (e) {
      print('CoinService: General error in getTransactions: $e');
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