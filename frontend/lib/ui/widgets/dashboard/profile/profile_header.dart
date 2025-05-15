// frontend/lib/ui/widgets/dashboard/profile/profile_header.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/models/user_profile_model.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/services/profile_service.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  User? _user;
  UserProfile? _userProfile;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Load user data from storage
      final user = await StorageService.getUser();
      if (user == null) {
        setState(() {
          _errorMessage = 'User not authenticated';
          _isLoading = false;
        });
        return;
      }

      // Load profile data from API
      final profileResult = await ProfileService.getProfile();
      setState(() {
        _user = user;
        if (profileResult['success']) {
          _userProfile = profileResult['data'];
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading profile: ${e.toString()}';
        _isLoading = false;
      });
      print('Error loading user data: $e');
    }
  }

  // Get name display from user data
  String _getDisplayName() {
    if (_user?.username != null && _user!.username.isNotEmpty) {
      return _user!.username;
    } else if (_user?.email != null && _user!.email.isNotEmpty) {
      // Get part before @ from email
      final name = _user!.email.split('@').first;
      // Capitalize name (first letter uppercase)
      if (name.isNotEmpty) {
        return name[0].toUpperCase() + name.substring(1);
      }
    }
    return 'User';
  }

  // Get avatar URL based on user data
  String _getAvatarUrl() {
    if (_user?.avatarUrl != null && _user!.avatarUrl!.isNotEmpty) {
      return _user!.avatarUrl!;
    } else if (_user?.email != null && _user!.email.isNotEmpty) {
      // Using UI Avatars API to generate avatar based on email
      final email = Uri.encodeComponent(_user!.email);
      return 'https://ui-avatars.com/api/?name=$email&background=random&color=fff&size=150';
    }
    
    // Default avatar if no user data available
    return 'https://ui-avatars.com/api/?name=User&background=random&color=fff&size=150';
  }

  // Calculate BMI if profile data is available
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
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
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
            style: blackTextStyle.copyWith(
              fontSize: 12,
              fontWeight: medium,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    // Create controllers for each field to set initial values
    final ageController = TextEditingController(text: _userProfile?.age?.toString() ?? '');
    final heightController = TextEditingController(text: _userProfile?.height?.toString() ?? '');
    final weightController = TextEditingController(text: _userProfile?.weight?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Profile',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input fields for profile editing
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
                labelStyle: greyTextStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                labelStyle: greyTextStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                labelStyle: greyTextStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: greyTextStyle,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Update profile implementation
              Navigator.pop(context);
              _loadUserData(); // Reload data after update
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E90FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Save',
              style: whiteTextStyle.copyWith(
                fontWeight: medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Stack(
      children: [
        // Background Image
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img_running_post.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          ),
        ),
        // Profile Info Container
        Container(
          margin: const EdgeInsets.only(top: 150),
          padding: const EdgeInsets.only(top: 60, bottom: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name, Followers, Claps, and Edit Profile in one row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getDisplayName(),
                            style: blackTextStyle.copyWith(
                              fontSize: 24,
                              fontWeight: semiBold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _user?.email ?? '',
                            style: greyTextStyle.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: _userProfile != null && _userProfile!.isComplete
                                ? Text(
                                    'Age: ${_userProfile!.age} years, Height: ${_userProfile!.height} cm, Weight: ${_userProfile!.weight} kg',
                                    style: blackTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                  )
                                : Text(
                                    'Complete your profile to track your health metrics better.',
                                    style: blackTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    // Stats and Edit Profile
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // BMI information if available
                        if (_userProfile != null && _userProfile!.isComplete) ...[
                          _buildBmiInfo(),
                          const SizedBox(height: 12),
                        ],
                        // Edit Profile Button
                        GestureDetector(
                          onTap: _showEditProfileDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.edit_outlined,
                                  size: 16,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Edit Profile',
                                  style: blackTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        // Profile Avatar
        Positioned(
          top: 100,
          left: MediaQuery.of(context).size.width / 2 - 180,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(_getAvatarUrl()),
            ),
          ),
        ),
      ],
    );
  }
}