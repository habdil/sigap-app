import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/login_bottom_sheet.dart'; // Import login bottom sheet
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/models/user_model.dart';

class RegisterBottomSheet extends StatefulWidget {
  const RegisterBottomSheet({Key? key}) : super(key: key);

  @override
  State<RegisterBottomSheet> createState() => _RegisterBottomSheetState();
}

class _RegisterBottomSheetState extends State<RegisterBottomSheet> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _privacyPolicyChecked = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          
          // Create Account text - aligned left with bigger font
          Text(
            'Create\nAccount',
            style: blackTextStyle.copyWith(
              fontSize: 32,
              fontWeight: extraBold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 32),
          
          // Username Field
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: 'Enter Username',
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
          
          // Email Field
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
          const SizedBox(height: 24),
          
          // Confirm Password Field
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Confirm Password',
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
          
          // Privacy Policy Checkbox
          Row(
            children: [
              Checkbox(
                value: _privacyPolicyChecked,
                onChanged: (value) {
                  setState(() {
                    _privacyPolicyChecked = value ?? false;
                  });
                },
                activeColor: orangeColor,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: greyTextStyle.copyWith(fontSize: 12),
                    children: [
                      TextSpan(
                        text: 'Privacy Policy',
                        style: blackTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: medium,
                          color: orangeColor,
                        ),
                      ),
                      TextSpan(
                        text: '.',
                        style: greyTextStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Register Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: (_privacyPolicyChecked && !_isLoading) ? () async {
                // Validate passwords match
                if (_passwordController.text != _confirmPasswordController.text) {
                  setState(() {
                    _errorMessage = 'Passwords do not match';
                  });
                  return;
                }
                
                // Clear any previous errors
                setState(() {
                  _errorMessage = null;
                  _isLoading = true;
                });
                
                // Call signup API
                try {
                  final result = await AuthService.signup(
                    username: _usernameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  
                  setState(() {
                    _isLoading = false;
                  });
                  
                  if (result['success']) {
                    // Show success message and close the sheet
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Registration successful! You can now login.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                    
                    // Show login sheet
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: const LoginBottomSheet(),
                        );
                      },
                    );
                  } else {
                    // Show error message
                    setState(() {
                      _errorMessage = result['message'];
                    });
                  }
                } catch (e) {
                  setState(() {
                    _isLoading = false;
                    _errorMessage = 'An unexpected error occurred. Please try again.';
                  });
                }
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _privacyPolicyChecked ? orangeColor : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                ? CircularProgressIndicator(color: whiteColor)
                : Text(
                    'Create Account',
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
          
          // Google button with same width as Register button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement Google registration
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
          
          // Sign In link
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: greyTextStyle.copyWith(fontSize: 14),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to login page
                    Navigator.pop(context);
                    
                    // Show the login bottom sheet
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: const LoginBottomSheet(),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Sign In',
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