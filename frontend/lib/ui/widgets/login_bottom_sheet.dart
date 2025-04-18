import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({Key? key}) : super(key: key);

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
          
          // Sign In Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement login logic
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: orangeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
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
                    // TODO: Navigate to register page
                    Navigator.pop(context);
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