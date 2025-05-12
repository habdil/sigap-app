import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class CommunitySection extends StatelessWidget {
  final VoidCallback onSeeMoreTapped;

  const CommunitySection({
    Key? key,
    required this.onSeeMoreTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Community Posts',
              style: blackTextStyle.copyWith(fontWeight: semiBold, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CommunityPostCard(
            username: 'SIGAP Official',
            timeAgo: '30 mnt',
            imageUrl: 'assets/img_running_post.png',
            description: 'Running For 4Hours Today',
            likes: '1,100',
            comments: '58',
            views: '1,300',
            onClapTap: () {},
            onMoreTap: () {},
          ),
        ),
        // Button: See More In Community
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: GestureDetector(
            onTap: onSeeMoreTapped,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  'See More In Community',
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CommunityPostCard extends StatelessWidget {
  final String username;
  final String timeAgo;
  final String imageUrl;
  final String description;
  final String likes;
  final String comments;
  final String views;
  final VoidCallback onClapTap;
  final VoidCallback onMoreTap;

  const CommunityPostCard({
    Key? key,
    required this.username,
    required this.timeAgo,
    required this.imageUrl,
    required this.description,
    required this.likes,
    required this.comments,
    required this.views,
    required this.onClapTap,
    required this.onMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header user info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile Picture
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/img_card_people.png'),
                ),
                const SizedBox(width: 12),
                // Username + Time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: greyTextStyle.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: onMoreTap,
                  child: Icon(Icons.more_horiz),
                ),
              ],
            ),
          ),
          // Post Image
          ClipRRect(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                  bottom: Radius.circular(10)),
              child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                        bottom: Radius.circular(12)),
                    child: Image.asset(
                      imageUrl,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ))),
          const SizedBox(height: 12),
          // Post Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              description,
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Reaction Row
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Like
                Row(
                  children: [
                    Image.asset(
                      'assets/icn_clap.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(likes,
                        style: blackTextStyle.copyWith(fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 16),
                // Comment
                Row(
                  children: [
                    Image.asset(
                      'assets/ic_comments.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(comments,
                        style: blackTextStyle.copyWith(fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 16),
                // Views
                Row(
                  children: [
                    Icon(Icons.remove_red_eye_outlined,
                        color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(views,
                        style: blackTextStyle.copyWith(fontSize: 12)),
                  ],
                ),
                Spacer(),
                // Button
                GestureDetector(
                  onTap: onClapTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '👏 Give a clap!',
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}