// frontend/lib/ui/widgets/dashboard/profile/latest_posts_section.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/dashboard/community_post_card.dart';

class LatestPostsSection extends StatelessWidget {
  const LatestPostsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest Posts',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        const SizedBox(height: 16),

        // Community Post Card
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
    );
  }
}