// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/blocs/user_bloc.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/splash_page.dart';
import 'package:frontend/providers/chatbot_provider.dart';
import 'package:frontend/config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase before checking user session
  await SupabaseConfig.initialize();
  
  // Check for existing user session
  await _checkUserSession();
  
  runApp(const MyApp());
}

// Check if user is already logged in
Future<void> _checkUserSession() async {
  final user = await StorageService.getUser();
  if (user != null) {
    UserBloc().setUser(user);
    
    // Jika menggunakan Supabase, kita juga bisa memastikan session tetap valid
    // Ini opsional, tergantung bagaimana autentikasi Anda diimplementasikan
    try {
      final session = SupabaseConfig.client.auth.currentSession;
      if (session == null || session.isExpired) {
        // Jika session Supabase tidak ada atau expired, logout user
        await StorageService.clearUser();
        UserBloc().clearUser();
      }
    } catch (e) {
      debugPrint('Error checking Supabase session: $e');
      // Abaikan error, tetap gunakan user dari storage
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add ChatbotProvider
        ChangeNotifierProvider(create: (_) => ChatbotProvider()),
        // You can add other providers here if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: lightBackgroundColor,
          appBarTheme: AppBarTheme(
            backgroundColor: lightBackgroundColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(
              color: blackColor,
            ),
            titleTextStyle: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: medium,
            ),
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}