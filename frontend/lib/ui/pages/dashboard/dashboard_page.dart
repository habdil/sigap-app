import 'package:flutter/material.dart';
import 'package:frontend/services/health_service.dart';
import 'package:frontend/shared/navbar.dart';
import 'package:frontend/ui/widgets/dashboard/activity_section.dart';
import 'package:frontend/ui/widgets/dashboard/article_section.dart';
import 'package:frontend/ui/widgets/dashboard/community_post_card.dart';
import 'package:frontend/ui/widgets/dashboard/header_section.dart';
import 'package:frontend/ui/widgets/dashboard/health_risk_card.dart';
import 'package:frontend/ui/widgets/dashboard/healthy_food_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _thoughtsController = TextEditingController();
  Map<String, dynamic>? _latestResult;
  bool _isLoadingResult = false;

  @override
  void initState() {
    super.initState();
    _fetchLatestResult();
  }

  @override
  void dispose() {
    _thoughtsController.dispose();
    super.dispose();
  }

  Future<void> _fetchLatestResult() async {
    setState(() {
      _isLoadingResult = true;
    });

    final result = await HealthService.getLatestResult();

    setState(() {
      if (result['success']) {
        _latestResult = result['data'];
      }
      _isLoadingResult = false;
    });
  }

  void _handleSubmitThoughts() {
    // TODO: Implement thoughts submission
    print('Submitted thoughts: ${_thoughtsController.text}');
    
    // Optionally clear the field
    _thoughtsController.clear();
    
    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thoughts submitted successfully')),
    );
  }

  void _handleSeeMoreActivities() {
    print('See more activities tapped');
    // TODO: Navigate to activities page
  }

  void _handleSeeMoreFood() {
    print('See more food tapped');
    // TODO: Navigate to food page
  }

  void _handleSeeMoreCommunity() {
    print('See more community posts tapped');
    // TODO: Navigate to community page
  }

  void _handleSeeAllArticles() {
    print('See all articles tapped');
    // TODO: Navigate to articles page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            HeaderSection(
              thoughtsController: _thoughtsController,
              onSubmitThoughts: _handleSubmitThoughts,
            ),
            
            const SizedBox(height: 24),
            
            // Health Risk Card
            HealthRiskCard(
              isLoading: _isLoadingResult,
              assessmentResult: _latestResult,
            ),
            
            const SizedBox(height: 24),
            
            // Activities Section
            ActivitySection(
              onSeeAllTapped: _handleSeeMoreActivities,
            ),
            
            const SizedBox(height: 24),
            
            // Healthy Food Section
            HealthyFoodSection(
              onTapSeeMore: _handleSeeMoreFood,
            ),
            
            const SizedBox(height: 24),
            
            // Community Section
            CommunitySection(
              onSeeMoreTapped: _handleSeeMoreCommunity,
            ),
            
            // Article Section
            ArticleSection(
              onSeeAllTapped: _handleSeeAllArticles,
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(initialIndex: 0),
    );
  }
}