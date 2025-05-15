import 'package:flutter/material.dart';
import 'package:frontend/models/article_model.dart';
import 'package:frontend/shared/theme.dart';

class Article extends StatelessWidget {
  final ArticleModel article;
  final Function() onTap;
  
  const Article({
    super.key, 
    required this.article, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth * 0.25; // 25% of screen width
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(right: 10),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Gambar
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: SizedBox(
                width: imageWidth,
                height: imageWidth * 1.1, // Slightly taller than wide for better appearance
                child: Image.asset(
                  article.imageAsset, // Use article image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Texts
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            article.title, // Use article title
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: blackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.more_horiz, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Read more>>',
                      style: orangeTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          article.source, // Use article source
                          style: greyTextStyle.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          article.timeAgo, // Use article timeAgo
                          style: greyTextStyle.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}