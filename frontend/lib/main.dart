import 'package:frontend/ui/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:frontend/blocs/user_bloc.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/shared/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _checkUserSession(); // Check for existing user session
  runApp(const MyApp());
}

// Check if user is already logged in
Future<void> _checkUserSession() async {
  final user = await StorageService.getUser();
  if (user != null) {
    UserBloc().setUser(user);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}