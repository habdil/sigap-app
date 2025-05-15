// lib/models/article_model.dart
class ArticleModel {
  final String id;
  final String title;
  final String source;
  final String imageAsset;
  final String content;
  final String date;
  final String timeAgo;

  ArticleModel({
    required this.id,
    required this.title,
    required this.source,
    required this.imageAsset,
    required this.content,
    required this.date,
    required this.timeAgo,
  });
}