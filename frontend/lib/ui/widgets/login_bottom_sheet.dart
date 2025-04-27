import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/dashboard_page.dart';
import 'package:frontend/ui/widgets/register_bottom_sheet.dart'; // Import register bottom sheet
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/blocs/user_bloc.dart';
import 'package:frontend/services/storage_service.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({Key? key}) : super(key: key);

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
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
              hintText: 'Enter Email/Username',
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

          // Password Field
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter Password',
              hintStyle: greyTextStyle,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: greyColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: blueColor),
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
              onPressed: !_isLoading
                  ? () async {
                      // Validate inputs
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        setState(() {
                          _errorMessage =
                              'Please enter email/username and password';
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
                        final result = await AuthService.login(
                          usernameOrEmail: _emailController.text,
                          password: _passwordController.text,
                        );

                        setState(() {
                          _isLoading = false;
                        });

                        if (result['success']) {
                          // Create user object from response
                          final userData = result['data'];
                          final user = User(
                            id: userData['id']?.toString(),
                            username:
                                userData['username'] ?? _emailController.text,
                            email: userData['email'] ?? _emailController.text,
                            token: userData['token'],
                          );

                          // Save user to storage
                          await StorageService.saveUser(user);

                          // Update user bloc
                          UserBloc().setUser(user);

                          // Show success message and close the sheet
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Login successful!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardPage()));
                          // Navigator.pop(context);

                          // TODO: Navigate to main app screen after login
                          // For now, just pop the modal
                        } else {
                          // Show error message
                          setState(() {
                            _errorMessage = result['message'];
                          });
                        }
                      } catch (e) {
                        setState(() {
                          _isLoading = false;
                          _errorMessage =
                              'An unexpected error occurred. Please try again.';
                        });
                      }
                    }
                  : null,
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

          // Google button with same width as Sign In button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement Google login
              },
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
    );
  }
}
