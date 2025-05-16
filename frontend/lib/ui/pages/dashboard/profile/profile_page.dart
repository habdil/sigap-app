// lib/ui/pages/dashboard/profile/profile_page.dart (updated)
import 'package:flutter/material.dart';
import 'package:frontend/shared/navbar.dart';
import 'package:frontend/ui/widgets/dashboard/profile/latest_posts_section.dart';
import 'package:frontend/ui/widgets/dashboard/profile/menu_icons_section.dart';
import 'package:frontend/ui/widgets/dashboard/profile/profile_header.dart';
import 'package:frontend/ui/widgets/dashboard/profile/recipe_post_card.dart';
import 'package:frontend/ui/widgets/dashboard/profile/sigap_points_card.dart';
import 'package:frontend/ui/widgets/dashboard/profile/logout.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header with Background Image
            ProfileHeader(),
            
            // Content Sections
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SIGAP Coins Section
                  SigapCoinsCard(),
                  
                  SizedBox(height: 24),
                  
                  // Menu Icons (now includes logout button)
                  MenuIconsSection(),
                  
                  SizedBox(height: 24),
                  
                  SizedBox(height: 24),
                  
                  // Recipes Posts
                  RecipePostCard(),
                  
                  SizedBox(height: 24),
                  
                  // Latest Posts
                  LatestPostsSection(),
                  
                  SizedBox(height: 20),
                  
                  LogoutButton(
                    width: double.infinity,
                    height: 56,
                    margin: EdgeInsets.symmetric(vertical: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(initialIndex: 3),
    );
  }
}