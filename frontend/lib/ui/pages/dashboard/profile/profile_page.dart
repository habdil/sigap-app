import 'package:flutter/material.dart';
import 'package:frontend/blocs/user_bloc.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/services/supabase_auth_service.dart';
import 'package:frontend/shared/navbar.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/auth/home_page.dart';
import 'package:frontend/ui/widgets/dashboard/community_post_card.dart';
import 'package:frontend/ui/widgets/dashboard/profile/latest_posts_section.dart';
import 'package:frontend/ui/widgets/dashboard/profile/menu_icons_section.dart';
import 'package:frontend/ui/widgets/dashboard/profile/profile_header.dart';
import 'package:frontend/ui/widgets/dashboard/profile/recipe_post_card.dart';
import 'package:frontend/ui/widgets/dashboard/profile/sigap_points_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header with Background Image
            const ProfileHeader(),
            
            // Content Sections
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SIGAP Coins Section
                  const SigapCoinsCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Menu Icons
                  const MenuIconsSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Community Section
                  // const CommunitySection(),
                  
                  const SizedBox(height: 24),
                  
                  // Recipes Posts
                  const RecipePostCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Latest Posts
                  const LatestPostsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(initialIndex: 3),
    );
  }
}