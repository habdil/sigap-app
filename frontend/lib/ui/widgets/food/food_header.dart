import 'package:flutter/material.dart';
import 'package:frontend/providers/chatbot_provider.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:frontend/models/user_profile_model.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/ui/pages/dashboard/chatbot/chatbot_page.dart';
import 'package:provider/provider.dart';

class FoodHeader extends StatefulWidget {
  const FoodHeader({Key? key}) : super(key: key);

  @override
  State<FoodHeader> createState() => _FoodHeaderState();
}

class _FoodHeaderState extends State<FoodHeader> {
  UserProfile? _userProfile;
  User? _user;
  final TextEditingController _thoughtsController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _thoughtsController.dispose();
    super.dispose();
  }

  // Load user data and profile
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get user data from storage
      final user = await StorageService.getUser();
      
      if (user != null) {
        setState(() {
          _user = user;
        });
        
        // Get profile from service
        final profileResult = await ProfileService.getProfile();
        
        if (profileResult['success']) {
          setState(() {
            _userProfile = profileResult['data'];
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // Get name from email
  String _getNameFromEmail() {
    if (_user != null && _user!.email.isNotEmpty) {
      // Get part before @ from email
      final name = _user!.email.split('@').first;
      // Capitalize name (first letter uppercase)
      if (name.isNotEmpty) {
        return name[0].toUpperCase() + name.substring(1);
      }
    }
    return 'User';
  }
  
  // Get avatar URL based on email
  String _getAvatarUrl() {
    if (_user != null && _user!.email.isNotEmpty) {
      // Using UI Avatars API to generate avatar based on email
      final email = Uri.encodeComponent(_user!.email);
      return 'https://ui-avatars.com/api/?name=$email&background=random&color=fff&size=150';
    }
    
    // Default avatar if email not available
    return 'https://ui-avatars.com/api/?name=User&background=random&color=fff&size=150';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            blueColor.withOpacity(0.8),
            orangeColor.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App bar with menu and profile
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.menu, color: Colors.white, size: 28),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white54,
                  backgroundImage: _isLoading 
                      ? null
                      : NetworkImage(_getAvatarUrl()),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Greeting if user is loaded
            if (!_isLoading && _user != null)
              Text(
                'Hello, ${_getNameFromEmail()}',
                style: whiteTextStyle.copyWith(
                  fontWeight: medium,
                  fontSize: 18,
                ),
              ),
            if (!_isLoading && _user != null)
              const SizedBox(height: 8),
            // Healthy Food title
            Text(
              'Healthy',
              style: whiteTextStyle.copyWith(
                fontWeight: semiBold,
                fontSize: 32,
              ),
            ),
            Text(
              'Food For',
              style: whiteTextStyle.copyWith(
                fontWeight: semiBold,
                fontSize: 32,
              ),
            ),
            Row(
              children: [
                Text(
                  'Healthy Life ',
                  style: whiteTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 32,
                  ),
                ),
                const Text(
                  '🌱',
                  style: TextStyle(fontSize: 28),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // "What you're going to eat" subtitle
            Text(
              "what you're going to eat",
              style: whiteTextStyle.copyWith(
                fontWeight: light,
                fontSize: 16,
              ),
            ),
            Text(
              "today??",
              style: whiteTextStyle.copyWith(
                fontWeight: light,
                fontSize: 16,
              ),
            ),
            // BMI info if available
            if (!_isLoading && _userProfile != null && _userProfile!.height != null && _userProfile!.weight != null)
              _buildBmiInfo(),
            const SizedBox(height: 20),
            // Search food health bar
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  // Build BMI info widget
  Widget _buildBmiInfo() {
    if (_userProfile == null || _userProfile!.height == null || _userProfile!.weight == null) {
      return const SizedBox.shrink();
    }
    
    // Calculate BMI
    final height = _userProfile!.height! / 100; // convert to meters
    final weight = _userProfile!.weight!;
    final bmi = weight / (height * height);
    
    // Determine BMI category
    String category;
    Color categoryColor;
    
    if (bmi < 18.5) {
      category = 'Underweight';
      categoryColor = Colors.blue;
    } else if (bmi < 25) {
      category = 'Normal';
      categoryColor = Colors.green;
    } else if (bmi < 30) {
      category = 'Overweight';
      categoryColor = Colors.orange;
    } else {
      category = 'Obese';
      categoryColor = Colors.red;
    }
    
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12, 
          vertical: 6
        ),
        decoration: BoxDecoration(
          color: whiteColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              color: categoryColor,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'BMI: ${bmi.toStringAsFixed(1)} - $category',
              style: whiteTextStyle.copyWith(
                fontSize: 12,
                fontWeight: medium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(35),
      ),
      child: TextField(
        controller: _thoughtsController,
        onTap: () {},
        decoration: InputDecoration(
          hintText: 'Your Thoughts...',
          hintStyle: greyTextStyle.copyWith(
            fontSize: 16, 
            fontWeight: light, 
            height: 1.0,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 35,
            vertical: 19,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              _sendToChatbot();
            },
            child: Container(
              width: 55,
              height: 50,
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFA726),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Transform.rotate(
                angle: -0.785398, // Rotasi 45 derajat dalam radian (mengarah ke kanan atas)
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ),
        ),
        onSubmitted: (_) {
          _sendToChatbot();
        },
      ),
    );
  }
  
  // Send the user's question to chatbot
  void _sendToChatbot() {
    final question = _thoughtsController.text.trim();
    if (question.isNotEmpty) {
      // Using the existing ChatBotPage widget
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatBotPage(),
        ),
      ).then((_) {
        // After returning from ChatBotPage
        final provider = Provider.of<ChatbotProvider>(context, listen: false);
        // Send message after a brief delay to allow the UI to initialize
        Future.delayed(Duration(milliseconds: 300), () {
          provider.sendMessage(question);
        });
        _thoughtsController.clear();
      });
    }
  }
}