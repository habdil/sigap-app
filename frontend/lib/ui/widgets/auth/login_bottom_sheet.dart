import 'package:flutter/material.dart';
import 'package:frontend/services/supabase_auth_service.dart';
import 'package:frontend/shared/notification.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/auth/auth_redirector.dart';
import 'package:frontend/ui/widgets/auth/register_bottom_sheet.dart'; // Import register bottom sheet
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/blocs/user_bloc.dart';
import 'package:frontend/services/storage_service.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true; // Tambahkan variabel untuk mengontrol visibilitas password

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

Future<void> _signInWithGoogle() async {
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });
  
  try {
    final authService = SupabaseAuthService();
    final success = await authService.handleGoogleSignIn(context);
    
    if (!mounted) return; // Tambahkan pengecekan ini untuk menghindari setState pada widget yang tidak mounted
    
    setState(() {
      _isLoading = false;
    });
    
    if (success) {
      // Close bottom sheet
      if (!mounted) return;
      Navigator.pop(context);
                
      // Navigate to the redirect page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthRedirector()),
      );
    }
  } catch (e) {
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _errorMessage = 'Terjadi kesalahan saat login dengan Google: ${e.toString()}';
    });
  }
}

@override
Widget build(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    padding: const EdgeInsets.all(24),
    // Tambahkan SingleChildScrollView di sini untuk membuat konten bisa di-scroll
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicator line at top - centered
          Center(
            child: Container(
              width: 50,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Welcome back text - now aligned left with bigger font
          Text(
            'Welcome\nBack User!',
            style: blackTextStyle.copyWith(
              fontSize: 32,
              fontWeight: extraBold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 32),
          
          // Email/Username Field
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Enter Email',
              hintStyle: greyTextStyle,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: greyColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: blueColor),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Password Field dengan toggle visibility
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Enter Password',
              hintStyle: greyTextStyle,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: greyColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: blueColor),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  // Ganti ikon berdasarkan status _obscurePassword
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: greyColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 36),
          
          // Error message display
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                _errorMessage!,
                style: blackTextStyle.copyWith(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
          
          // Sign In Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: !_isLoading ? () async {
                // Validate inputs
                if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                  setState(() {
                    _errorMessage = 'Please enter email/username and password';
                  });
                  return;
                }
                
                // Clear any previous errors
                setState(() {
                  _errorMessage = null;
                  _isLoading = true;
                });
                
                // Call login API
                try {
                  setState(() {
                    _errorMessage = null;
                    _isLoading = true;
                  });
                  
                  final result = await AuthService.login(
                    usernameOrEmail: _emailController.text,
                    password: _passwordController.text,
                  );
                  
                  if (!mounted) return;
                  
                  setState(() {
                    _isLoading = false;
                  });
                  
                  if (result['success']) {
                    try {
                      // Create user object from response with proper null safety
                      final userData = result['data'];
                      
                      // Validasi data yang diterima
                      if (userData == null) {
                        throw Exception("Invalid response data: userData is null");
                      }
                      
                      // Error will occur here if any keys are missing or null
                      print('User data from response: $userData');
                      
                      final user = User(
                        id: (userData['id'] ?? '0').toString(), // Gunakan null safety
                        username: userData['username'] ?? _emailController.text,
                        email: userData['email'] ?? _emailController.text,
                        token: userData['token'] as String?, // Cast sebagai nullable String
                      );
                      
                      // Validasi token
                      if (user.token == null || user.token!.isEmpty) {
                        throw Exception("Invalid token received from server");
                      }
                      
                      // Save user to storage
                      await StorageService.saveUser(user);
                      await StorageService.saveToken(user.token!);
                      
                      // Update user bloc
                      UserBloc().setUser(user);
                      
                      if (!mounted) return;
                      
                      // Show success notification
                      context.showSuccessNotification(
                        title: "Login Success!",
                        message: "Welcome ${user.username}, your account and password are correct",
                      );
                      
                      // Close bottom sheet and navigate
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const AuthRedirector()),
                      );
                    } catch (dataError) {
                      // Tangkap error saat mengolah data respons
                      print('Error processing response data: $dataError');
                      setState(() {
                        _errorMessage = 'Error processing server response: ${dataError.toString()}';
                      });
                      
                      context.showErrorNotification(
                        title: "Login Error!",
                        message: "There was a problem with the server response. Please try again.",
                      );
                    }
                  } else {
                    // Show error message from response
                    setState(() {
                      _errorMessage = result['message'] ?? "Your username or password is incorrect, please try again!";
                    });
                    
                    context.showErrorNotification(
                      title: "Login Failed!",
                      message: _errorMessage!,
                    );
                  }
                } catch (e) {
                  // Tangkap error saat melakukan login request
                  print('Login request error: $e');
                  
                  if (!mounted) return;
                  
                  setState(() {
                    _isLoading = false;
                    _errorMessage = 'An unexpected error occurred: ${e.toString()}';
                  });
                  
                  context.showErrorNotification(
                    title: "Login Error!",
                    message: "An unexpected error occurred. Please try again.",
                  );
                }
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: orangeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                ? CircularProgressIndicator(color: whiteColor)
                : Text(
                    'Sign In',
                    style: whiteTextStyle.copyWith(
                      fontWeight: semiBold,
                      fontSize: 16,
                    ),
                  ),
            ),
          ),
          
          // OR divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: greyColor.withOpacity(0.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'or',
                    style: greyTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: greyColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: !_isLoading ? _signInWithGoogle : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: greyColor.withOpacity(0.2)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/ic_google.png',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 12),
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
          
          // Create account link
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: greyTextStyle.copyWith(fontSize: 14),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to register page
                    Navigator.pop(context);
                    
                    // Show the register bottom sheet
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: const RegisterBottomSheet(),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Create account',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Add extra padding at bottom for keyboard
          const SizedBox(height: 16),
        ],
      ),
     ),
    );
  }
}