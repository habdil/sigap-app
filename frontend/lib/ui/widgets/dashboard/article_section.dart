// lib/ui/widgets/dashboard/article_section.dart
import 'package:flutter/material.dart';
import 'package:frontend/services/article_service.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/dashboard/article_detail_screen.dart';
import 'package:frontend/ui/widgets/dashboard/article_list_screen.dart';
import 'package:frontend/ui/widgets/dashboard/daily_health_article.dart';

class ArticleSection extends StatelessWidget {
  final VoidCallback onSeeAllTapped;

  const ArticleSection({
    Key? key,
    required this.onSeeAllTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily health article',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to article list screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArticleListScreen(),
                    ),
                  );
                },
                child: Text(
                  'see all',
                  style: orangeTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // List of Articles
          Column(
            children: articleServices.map((article) => 
              Article(
                article: article,
                onTap: () {
                  // Navigate to article detail screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailScreen(article: article),
                    ),
                  );
                },
              )
            ).toList(),
          ),
        ],
      ),
    );
  }
}