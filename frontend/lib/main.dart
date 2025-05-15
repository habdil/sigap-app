// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/blocs/user_bloc.dart';
import 'package:frontend/blocs/food_bloc.dart';
import 'package:frontend/blocs/activity_bloc.dart'; 
import 'package:frontend/blocs/coin_bloc.dart'; 
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/splash_page.dart';
import 'package:frontend/providers/chatbot_provider.dart';
import 'package:frontend/config/supabase_config.dart';
import '../config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize();
  
  // Initialize Supabase before checking user session
  await SupabaseConfig.initialize();
  
  // Check for existing user session
  await _checkUserSession();
  
  runApp(const MyApp());
}

// Check if user is already logged in
Future<void> _checkUserSession() async {
  debugPrint('main: Checking user session');
  final user = await StorageService.getUser();
  if (user != null) {
    debugPrint('main: Found existing user session');
    UserBloc().setUser(user);
    
    // Jika menggunakan Supabase, kita juga bisa memastikan session tetap valid
    // Ini opsional, tergantung bagaimana autentikasi Anda diimplementasikan
    try {
      final session = SupabaseConfig.client.auth.currentSession;
      if (session == null || session.isExpired) {
        debugPrint('main: Supabase session expired or not found');
        // Jika session Supabase tidak ada atau expired, logout user
        await StorageService.clearUser();
        UserBloc().clearUser();
      } else {
        debugPrint('main: Supabase session valid');
      }
    } catch (e) {
      debugPrint('main: Error checking Supabase session: $e');
      // Abaikan error, tetap gunakan user dari storage
    }
  } else {
    debugPrint('main: No user session found');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('main: Building MyApp');
    return MultiBlocProvider(
      providers: [
        // Add FoodBloc
        BlocProvider<FoodBloc>(
          create: (context) => FoodBloc(),
        ),
        // Tambahkan BlocProvider lain jika diperlukan
      ],
      child: MultiProvider(
        providers: [
          // Add ChatbotProvider
          ChangeNotifierProvider(create: (_) => ChatbotProvider()),
          // Tambahkan ActivityBloc dan CoinBloc sebagai ChangeNotifierProvider
          ChangeNotifierProvider(create: (_) => ActivityBloc()),
          ChangeNotifierProvider(create: (_) => CoinBloc()),
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
      ),
    );
  }
}