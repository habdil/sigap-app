import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/dashboard/chatbot/chatbot_page.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:frontend/models/user_profile_model.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/models/user_model.dart';

class HeaderSection extends StatefulWidget {
  final TextEditingController thoughtsController;
  final VoidCallback onSubmitThoughts;

  const HeaderSection({
    super.key,
    required this.thoughtsController,
    required this.onSubmitThoughts,
  });

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  UserProfile? _userProfile;
  User? _user;
  String _greeting = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setGreeting();
  }

  // Set greeting based on time of day
  void _setGreeting() {
    final hour = DateTime.now().hour;
    setState(() {
      if (hour < 12) {
        _greeting = 'Good Morning';
      } else if (hour < 17) {
        _greeting = 'Good Afternoon';
      } else {
        _greeting = 'Good Evening';
      }
    });
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

  // Navigate to ChatBotPage
  void _navigateToChatbot() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatBotPage()),
    );
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
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate adaptive dimensions
    final containerHeight = _getAdaptiveContainerHeight(screenHeight);
    final avatarSize = _getAdaptiveAvatarSize(screenWidth);
    final buttonIconSize = _getAdaptiveIconSize(screenWidth);
    final textScaleFactor = _getAdaptiveTextScaleFactor(screenWidth);
    
    // Calculate paddings based on screen size
    final horizontalPadding = screenWidth * 0.06;
    final topPadding = containerHeight * 0.1;
    final bottomPadding = containerHeight * 0.05;
    
    return Container(
      width: double.infinity,
      height: containerHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            blueColor.withOpacity(0.8),
            orangeColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(screenWidth * 0.08),
          bottomRight: Radius.circular(screenWidth * 0.08),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding, 
          topPadding, 
          horizontalPadding, 
          bottomPadding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with avatar and AI Assistant button
            _buildTopRow(avatarSize, buttonIconSize, textScaleFactor),
            SizedBox(height: containerHeight * 0.03),
            
            // Daily mindfulness text
            Text(
              'Daily Mindfulness Check-in',
              style: whiteTextStyle.copyWith(
                fontWeight: light, 
                fontSize: 14 * textScaleFactor
              ),
            ),
            SizedBox(height: containerHeight * 0.02),
            
            // Greeting with user name
            Text(
              _isLoading
                  ? 'Hello 👋'
                  : 'Hello, ${_getNameFromEmail()} 👋',
              style: whiteTextStyle.copyWith(
                fontWeight: semiBold, 
                fontSize: 20 * textScaleFactor
              ),
            ),
            SizedBox(height: containerHeight * 0.01),
            
            // Time-based greeting
            Text(
              _greeting,
              style: whiteTextStyle.copyWith(
                fontWeight: medium, 
                fontSize: 16 * textScaleFactor
              ),
            ),
            SizedBox(height: containerHeight * 0.015),
            
            // BMI info if available
            if (_userProfile != null && _userProfile!.height != null && _userProfile!.weight != null) ...[
              _buildBmiInfo(textScaleFactor),
              SizedBox(height: containerHeight * 0.015),
            ],
            
            // Motivational text
            Expanded(
              child: Text(
                "Let's Track Your Progress,\nHow Are You Feeling \nToday?",
                style: whiteTextStyle.copyWith(
                  fontWeight: light, 
                  fontSize: 16 * textScaleFactor
                ),
              ),
            ),
            
            // Input field
            _buildInputField(textScaleFactor),
          ],
        ),
      ),
    );
  }
  
  // Build top row with avatar and AI Assistant button
  Widget _buildTopRow(double avatarSize, double iconSize, double textScaleFactor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Avatar - clickable to navigate to ChatBotPage
        GestureDetector(
          onTap: _navigateToChatbot,
          child: Stack(
            children: [
              _isLoading 
                ? CircleAvatar(
                    radius: avatarSize,
                    backgroundColor: Colors.grey[300],
                    child: Center(
                      child: SizedBox(
                        width: avatarSize * 0.7,
                        height: avatarSize * 0.7,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: avatarSize,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(_getAvatarUrl()),
                  ),
              // Indicator that avatar is clickable
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: avatarSize * 0.6,
                  height: avatarSize * 0.6,
                  decoration: BoxDecoration(
                    color: orangeColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // AI Assistant button
        GestureDetector(
          onTap: _navigateToChatbot,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12 * textScaleFactor, 
              vertical: 8 * textScaleFactor
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20 * textScaleFactor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: blueColor,
                  size: iconSize,
                ),
                SizedBox(width: 4 * textScaleFactor),
                Text(
                  'AI Assistant',
                  style: blackTextStyle.copyWith(
                    fontSize: 12 * textScaleFactor,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  // Build BMI info widget
  Widget _buildBmiInfo(double textScaleFactor) {
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
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12 * textScaleFactor, 
        vertical: 6 * textScaleFactor
      ),
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12 * textScaleFactor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite,
            color: categoryColor,
            size: 16 * textScaleFactor,
          ),
          SizedBox(width: 6 * textScaleFactor),
          Text(
            'BMI: ${bmi.toStringAsFixed(1)} - $category',
            style: whiteTextStyle.copyWith(
              fontSize: 12 * textScaleFactor,
              fontWeight: medium,
            ),
          ),
        ],
      ),
    );
  }
  
  // Build input field widget
  Widget _buildInputField(double textScaleFactor) {
    return Container(
      height: 60 * textScaleFactor,
      margin: EdgeInsets.only(bottom: 5 * textScaleFactor),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(35 * textScaleFactor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text input
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 24 * textScaleFactor),
              child: TextField(
                controller: widget.thoughtsController,
                decoration: InputDecoration(
                  hintText: 'Your Thoughts...',
                  hintStyle: greyTextStyle.copyWith(
                    fontSize: 14 * textScaleFactor, 
                    fontWeight: medium,
                    color: Colors.grey.shade500,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15 * textScaleFactor,
                  ),
                ),
                style: blackTextStyle.copyWith(
                  fontSize: 16 * textScaleFactor,
                  fontWeight: medium,
                ),
                cursorColor: orangeColor,
                onSubmitted: (_) {
                  // When user presses Enter on keyboard
                  if (widget.thoughtsController.text.trim().isNotEmpty) {
                    widget.onSubmitThoughts();
                  } else {
                    _navigateToChatbot();
                  }
                },
              ),
            ),
          ),
          
          // Submit button
          Container(
            width: 38 * textScaleFactor,
            height: 38 * textScaleFactor,
            margin: EdgeInsets.only(right: 6 * textScaleFactor),
            decoration: BoxDecoration(
              color: orangeColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: orangeColor.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24 * textScaleFactor),
                onTap: () {
                  // If there's text input, use onSubmitThoughts
                  // Otherwise, navigate to ChatBotPage
                  if (widget.thoughtsController.text.trim().isNotEmpty) {
                    widget.onSubmitThoughts();
                  } else {
                    _navigateToChatbot();
                  }
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 22 * textScaleFactor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper methods for adaptive sizing
  
  // Get adaptive container height based on screen height
  double _getAdaptiveContainerHeight(double screenHeight) {
    // Calculate height as percentage of screen height, with min/max constraints
    final percentage = screenHeight < 600 ? 0.35 : 0.45;
    final calculatedHeight = screenHeight * percentage;
    
    // Apply constraints
    if (calculatedHeight < 220) return 220; // Minimum height
    if (calculatedHeight > 400) return 400; // Maximum height
    return calculatedHeight;
  }
  
  // Get adaptive avatar size based on screen width
  double _getAdaptiveAvatarSize(double screenWidth) {
    if (screenWidth < 320) return 24; // Very small devices
    if (screenWidth < 360) return 26; // Small devices
    if (screenWidth > 600) return 32; // Large devices
    return 28; // Default for medium devices
  }
  
  // Get adaptive icon size based on screen width
  double _getAdaptiveIconSize(double screenWidth) {
    if (screenWidth < 320) return 14; // Very small devices
    if (screenWidth < 360) return 15; // Small devices
    if (screenWidth > 600) return 18; // Large devices
    return 16; // Default for medium devices
  }
  
  // Get adaptive text scale factor based on screen width
  double _getAdaptiveTextScaleFactor(double screenWidth) {
    if (screenWidth < 320) return 0.85; // Very small devices
    if (screenWidth < 360) return 0.9; // Small devices
    if (screenWidth > 600) return 1.2; // Large devices
    return 1.0; // Default for medium devices
  }
}