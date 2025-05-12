// lib/ui/widgets/auth/auth_redirector.dart
import 'package:flutter/material.dart';
import 'package:frontend/services/health_service.dart';
import 'package:frontend/ui/pages/profile/profile_setup_page.dart';
import 'package:frontend/ui/pages/dashboard/dashboard_page.dart';
import 'package:frontend/shared/notification.dart';
import 'package:frontend/shared/theme.dart';

class AuthRedirector extends StatefulWidget {
  const AuthRedirector({super.key});

  @override
  State<AuthRedirector> createState() => _AuthRedirectorState();
}

class _AuthRedirectorState extends State<AuthRedirector> {
  bool _isLoading = true;
  String _statusMessage = "Checking your profile...";
  
  @override
  void initState() {
    super.initState();
    // Tunggu widget fully rendered sebelum check status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserStatus();
    });
  }

  Future<void> _checkUserStatus() async {
    try {
      // Cek status assessment menggunakan HealthService
      final assessmentStatus = await HealthService.checkAssessmentStatus();
      
      if (!mounted) return;
      
      if (assessmentStatus['success']) {
        // Redirect langsung tanpa menunjukkan loading lagi
        if (assessmentStatus['needsAssessment']) {
          // User perlu mengisi assessment
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
          );
        } else {
          // User sudah pernah mengisi assessment, arahkan ke dashboard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        }
      } else {
        // Jika gagal cek status, arahkan ke profile setup dengan pesan error
        if (mounted) {
          context.showErrorNotification(
            title: "Error",
            message: assessmentStatus['message'] ?? "Failed to check assessment status",
          );
          
          // Langsung arahkan ke ProfileSetupPage
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      
      context.showErrorNotification(
        title: "Error",
        message: "An unexpected error occurred",
      );
      
      // Langsung arahkan ke ProfileSetupPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo aplikasi (opsional)
              // Image.asset('assets/logo.png', width: 120, height: 120),
              // const SizedBox(height: 24),
              
              // Indicator loading yang sederhana
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(orangeColor),
              ),
              const SizedBox(height: 20),
              
              // Pesan status
              Text(
                _statusMessage,
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}