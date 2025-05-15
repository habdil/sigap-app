// lib/ui/screens/article/article_list_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend/services/article_service.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/dashboard/article_detail_screen.dart';
import 'package:frontend/ui/widgets/dashboard/daily_health_article.dart';

class ArticleListScreen extends StatelessWidget {
  const ArticleListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Health Articles',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: blackColor),
            onPressed: () {
              // Search functionality would go here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Featured article
              if (articleServices.isNotEmpty) _buildFeaturedArticle(context, articleServices.first),
              
              const SizedBox(height: 24),
              
              // Categories
              _buildCategories(),
              
              const SizedBox(height: 24),
              
              // All articles
              Text(
                'All Articles',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // List of all articles
              Column(
                children: articleServices.map((article) => 
                  Article(
                    article: article,
                    onTap: () {
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
        ),
      ),
    );
  }
  
  Widget _buildFeaturedArticle(BuildContext context, dynamic article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(article.imageAsset),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: orangeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Featured',
                  style: whiteTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                article.title,
                style: whiteTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    article.source,
                    style: whiteTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    article.timeAgo,
                    style: whiteTextStyle.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCategories() {
    final categories = [
      {'name': 'All', 'icon': Icons.article, 'color': orangeColor},
      {'name': 'Health', 'icon': Icons.favorite, 'color': Colors.red},
      {'name': 'Diet', 'icon': Icons.restaurant, 'color': Colors.green},
      {'name': 'Fitness', 'icon': Icons.fitness_center, 'color': Colors.blue},
      {'name': 'Mental', 'icon': Icons.psychology, 'color': Colors.purple},
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              final isSelected = category['name'] == 'All';
              return Container(
                margin: const EdgeInsets.only(right: 12, bottom: 8),
                child: Material(
                  color: isSelected ? category['color'] as Color : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      // Category filter would go here
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            category['icon'] as IconData,
                            size: 18,
                            color: isSelected ? Colors.white : category['color'] as Color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category['name'] as String,
                            style: isSelected
                                ? whiteTextStyle.copyWith(fontWeight: medium)
                                : blackTextStyle.copyWith(fontWeight: medium),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}