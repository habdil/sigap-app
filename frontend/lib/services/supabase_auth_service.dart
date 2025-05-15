// lib/services/supabase_auth_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart' hide User; // Penting untuk hide User!
import 'package:frontend/config/supabase_config.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/blocs/user_bloc.dart';
import 'package:frontend/shared/notification.dart';

class SupabaseAuthService {
  final SupabaseClient _supabase = SupabaseConfig.client;
  
  // Dapatkan base URL dari konfigurasi
  static String get baseUrl => '${AppConfig.instance.apiBaseUrl}/auth';
  static int get timeout => AppConfig.instance.timeout; // Replace with your actual API URL
  
  // Fungsi utama untuk Google Sign In yang akan dipanggil dari berbagai tombol
  Future<bool> handleGoogleSignIn(BuildContext context) async {
    try {
      debugPrint('🔍 Memulai proses Google Sign In');
      
      // 1. Lakukan autentikasi dengan Google melalui Supabase
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.example.frontend://',  // Gunakan URL scheme yang telah dikonfigurasi
        queryParams: {
          'prompt': 'select_account',  // Force account selection
        },
      );
      
      // Tunggu beberapa detik agar autentikasi selesai
      await Future.delayed(const Duration(seconds: 2));
      
      // Periksa session setelah autentikasi
      final session = _supabase.auth.currentSession;
      
      if (session == null) {
        debugPrint('❌ Tidak ada session setelah autentikasi');
        context.showErrorNotification(
          title: "Login Gagal!",
          message: "Tidak dapat mendapatkan sesi login. Silakan coba lagi.",
        );
        return false;
      }
      
      // Data user dari Supabase
      final supabaseUser = session.user;
      final userMetadata = supabaseUser.userMetadata;
      
      debugPrint('✅ Authentication berhasil dengan session: ${supabaseUser.email}');
      
      // Kirim data ke backend untuk integrasi dengan database utama
      final backendResponse = await _registerWithBackend(
        supabaseUUID: supabaseUser.id,
        email: supabaseUser.email ?? '',
        username: userMetadata?['name'] ?? supabaseUser.email?.split('@').first ?? 'User',
        googleId: userMetadata?['sub'] ?? '',
        avatarUrl: userMetadata?['avatar_url'],
      );
      
      if (!backendResponse['success']) {
        debugPrint('❌ Backend integration failed: ${backendResponse['message']}');
        context.showErrorNotification(
          title: "Registrasi Gagal!",
          message: backendResponse['message'] ?? "Gagal mendaftarkan akun Google ke sistem. Silakan coba lagi.",
        );
        return false;
      }
      
      // Format yang benar untuk data
      // Ini disesuaikan dengan struktur response di AuthService.login
      final userData = backendResponse['data'];
      final userInfo = userData['user'] ?? userData; // Flexible response handling
      
      final userModel = User(
        id: userInfo['id']?.toString() ?? '0',
        username: userInfo['username'] ?? userMetadata?['name'] ?? 'User',
        email: userInfo['email'] ?? supabaseUser.email ?? '',
        token: userData['token'], // Token dari backend, bukan dari Supabase
      );
      
      // Simpan user ke storage
      await StorageService.saveUser(userModel);
      await StorageService.saveToken(userData['token']);
      
      // Update user bloc
      UserBloc().setUser(userModel);
      
      // Tampilkan pesan sukses
      context.showSuccessNotification(
        title: "Google Login Berhasil!",
        message: "Selamat datang ${userModel.username}, Anda berhasil masuk dengan Google",
      );
      
      return true;
      
    } catch (error) {
      debugPrint('⚠️ Exception selama Google Sign In: $error');
      debugPrint('Stack trace: ${StackTrace.current}');
      
      context.showErrorNotification(
        title: "Login Error!",
        message: "Terjadi kesalahan saat proses login dengan Google: ${error.toString()}",
      );
      return false;
    }
  }
  
  // Fungsi untuk register/login ke backend Golang
  Future<Map<String, dynamic>> _registerWithBackend({
    required String supabaseUUID,
    required String email,
    required String username,
    String? googleId,
    String? avatarUrl,
  }) async {
    try {
      debugPrint('🔄 Menghubungi backend untuk integrasi: $baseUrl/supabase-auth');
      
      final response = await http.post(
        Uri.parse('$baseUrl/supabase-auth'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'supabase_uuid': supabaseUUID,
          'email': email,
          'username': username,
          'google_id': googleId ?? '',
          'avatar_url': avatarUrl ?? '',
        }),
      ).timeout(const Duration(seconds: 15));
      
      debugPrint('🔄 Status response backend: ${response.statusCode}');
      
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
            'message': responseData['message'] ?? responseData['error'] ?? 'Gagal mendaftarkan user. Status code: ${response.statusCode}',
          };
        }
      } catch (parseError) {
        return {
          'success': false,
          'message': 'Server mengembalikan format yang tidak valid. Status code: ${response.statusCode}',
          'details': response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body,
        };
      }
    } catch (e) {
      debugPrint('❌ Error backend integration: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
  
  // Logout dari Supabase dan app
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    await StorageService.clearAll();
    UserBloc().clearUser();
  }
}