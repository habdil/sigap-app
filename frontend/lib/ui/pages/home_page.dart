import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/login_bottom_sheet.dart';
import 'package:frontend/ui/widgets/register_bottom_sheet.dart'; // Import the register bottom sheet

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              blueColor.withOpacity(0.8),
              orangeColor.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Gambar orang lari yang digeser dan dikecilkan
              Positioned(
                top: 20, // Posisi lebih ke atas
                left: -10, // Posisi lebih ke kiri
                right: 50, // Memberi ruang di kanan agar gambar terlihat lebih ke kiri
                bottom: 250, // Memberi ruang di bawah
                child: Image.asset(
                  'assets/img_orangLari.png',
                  fit: BoxFit.contain,
                ),
              ),
              
              // Overlay konten (logo, teks, tombol)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(flex: 4),
                    
                    // Let's Get Started image positioned near bottom, closer to buttons
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Image.asset(
                        'assets/img_sigap_letsGetStarted.png',
                        width: 224,
                        height: 178,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Sign In button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Tampilkan bottom sheet di sini
                          _showLoginBottomSheet(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Have an account? Sign In',
                          style: blackTextStyle.copyWith(
                            fontWeight: semiBold,
                          ),
                        ),
                      ),
                    ),
                    
                    // OR divider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: whiteColor.withOpacity(0.5),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'or',
                              style: whiteTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: whiteColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Google login button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implementasi login dengan Google
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/ic_google.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Sign in with Google',
                              style: blackTextStyle.copyWith(
                                fontWeight: medium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Create account text
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            // Show register bottom sheet
                            _showRegisterBottomSheet(context);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: whiteTextStyle.copyWith(fontSize: 14),
                              children: [
                                TextSpan(
                                  text: 'Create account',
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan bottom sheet
  void _showLoginBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ini penting agar bottom sheet bisa memenuhi konten
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Mengatasi keyboard
          ),
          child: const LoginBottomSheet(),
        );
      },
    );
  }
  
  // Fungsi untuk menampilkan register bottom sheet
  void _showRegisterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Agar bottom sheet bisa memenuhi konten
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Mengatasi keyboard
          ),
          child: const RegisterBottomSheet(),
        );
      },
    );
  }
}