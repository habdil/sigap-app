import 'package:flutter/material.dart';
import 'package:frontend/blocs/user_bloc.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/services/supabase_auth_service.dart';
import 'package:frontend/shared/navbar.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/auth/home_page.dart';
import 'package:frontend/ui/widgets/dashboard/community_post_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header with Background Image
            Stack(
              children: [
                // Background Image
                Container(
                  height: 200, // Adjusted height to better fit the design
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img_running_post.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), // Add slight darkening overlay
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
                // Profile Info Container
                Container(
                  margin: const EdgeInsets.only(top: 150), // Adjusted to better position the white card
                  padding: const EdgeInsets.only(top: 60, bottom: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
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
                    crossAxisAlignment: CrossAxisAlignment.start, // Mengubah dari center menjadi start
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
                                    'Sigap Official',
                                    style: blackTextStyle.copyWith(
                                      fontSize: 24,
                                      fontWeight: semiBold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'health advisor',
                                    style: greyTextStyle.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      'just likes to do interesting and healthy things for everyone.',
                                      style: blackTextStyle.copyWith(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Followers, Claps, and Edit Profile
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Followers and Claps
                                Row(
                                  children: [
                                    Text(
                                      '4k Followers',
                                      style: blackTextStyle.copyWith(
                                        fontSize: 14,
                                        fontWeight: medium,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '|',
                                      style: greyTextStyle.copyWith(fontSize: 14),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '1.6k Claps',
                                      style: blackTextStyle.copyWith(
                                        fontSize: 14,
                                        fontWeight: medium,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Edit Profile Button
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
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
                  top: 100, // Adjusted to position avatar properly
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
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/icn_user.png'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // SIGAP Coins Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SIGAP Coins Card
                  // SIGAP Coins Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SIGAP Coins Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SIGAP Coins',
                              style: blackTextStyle.copyWith(
                                fontSize: 20,
                                fontWeight: semiBold,
                              ),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icn_clap.png',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '10,206',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: bold,
                                    color: Color(0xFFFF7A45),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Progress Bar - Blue to Orange Gradient
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 10,
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: Colors.grey.shade200,
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.6,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue,
                                          Color(0xFFFF7A45),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSmallButton('your points', Colors.grey.shade200),
                            _buildSmallButton('GET : Sigap Shoes', Color(0xFFFF7A45), textColor: Colors.white, fontSize: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Menu Icons
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildIconMenu('10 recipes', 'assets/icn_eat.png'),
                        _buildVerticalDivider(),
                        _buildIconMenu('4km run\na week', 'assets/icn_run.png'),
                        _buildVerticalDivider(),
                        _buildIconMenu('Post Goal', Icons.post_add),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Community Section
                  Text(
                    'Community',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Community Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildCommunityCard(
                          'Maraphtoon',
                          'Jogging running community that you can participate in the marathon every day',
                          'Joined',
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCommunityCard(
                          'Yogya Joging',
                          'Jogging running community that you can participate in the marathon every day',
                          'Join',
                          Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Recipes Posts
                  Text(
                    'Recipes Posts',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Recipe Card
                  RecipePostCard(),
                  
                  const SizedBox(height: 24),
                  
                  Text(
                    'Latest Posts',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Community Post Card (directly calling CommunityPostCard instead of CommunitySection)
                  CommunityPostCard(
                    username: 'SIGAP Official',
                    timeAgo: '30 mnt',
                    imageUrl: 'assets/img_running_post.png',
                    description: 'Running For 4Hours Today',
                    likes: '1,100',
                    comments: '58',
                    views: '1,300',
                    onClapTap: () {
                      // Handle clap tap
                      print('Clap button tapped');
                    },
                    onMoreTap: () {
                      // Handle more options tap
                      print('More options tapped');
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(initialIndex: 3),
    );
  }

  Widget _buildProfileItem(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: orangeColor,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: blackTextStyle,
            ),
          ),
          Text(
            value,
            style: blackTextStyle.copyWith(
              fontWeight: semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthItem(String title, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: blackTextStyle,
        ),
        Text(
          value,
          style: blackTextStyle.copyWith(
            fontWeight: bold,
            color: valueColor,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildRiskFactorItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: orangeColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: blackTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton(String text, Color bgColor, {Color? textColor, double? fontSize}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: blackTextStyle.copyWith(
          fontSize: fontSize ?? 12,
          fontWeight: medium,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildIconMenu(String text, dynamic icon) {
    return Column(
      children: [
        icon is IconData
            ? Icon(
                icon,
                color: orangeColor,
                size: 24,
              )
            : Image.asset(
                icon,
                width: 24,
                height: 24,
              ),
        const SizedBox(height: 8),
        Text(
          text,
          style: blackTextStyle.copyWith(
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  Widget _buildCommunityCard(String title, String description, String buttonText, Color buttonColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: blackTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: greyTextStyle.copyWith(
              fontSize: 12,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              buttonText,
              style: buttonColor == Colors.grey 
                ? blackTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                  )
                : whiteTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipePostCard extends StatelessWidget {
  const RecipePostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image that fills the entire card
          Positioned.fill(
            child: Image.asset(
              'assets/bg_salad.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Gradient overlay to ensure text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.4),
                    Colors.white,
                  ],
                  stops: const [0.0, 0.5, 0.8],
                ),
              ),
            ),
          ),
          
          // Content - Right aligned
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'salad recipe recommendations',
                    style: blackTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: semiBold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'click for recipe',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: medium,
                          color: Color(0xFFFF7A45),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        color: Color(0xFFFF7A45),
                        size: 18,
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Color(0xFFFF7A45),
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Make the entire card clickable
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Handle recipe card tap
                  print('Recipe card tapped');
                },
                splashColor: Colors.white.withOpacity(0.1),
                highlightColor: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}