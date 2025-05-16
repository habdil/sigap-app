import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/dashboard/activity/history/activity_detail_page.dart';
import 'package:frontend/ui/widgets/activites/overview_activites/history_activity_item.dart';
import 'package:frontend/models/activity_model.dart';
import 'package:frontend/blocs/activity_bloc.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:frontend/ui/pages/dashboard/activity/history/all_history_activites.dart';

/// History activities section with grid
class HistoryActivitiesSection extends StatefulWidget {
  const HistoryActivitiesSection({super.key});

  @override
  State<HistoryActivitiesSection> createState() => _HistoryActivitiesSectionState();
}

class _HistoryActivitiesSectionState extends State<HistoryActivitiesSection> {
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    // Load activities when widget initializes if not loaded already
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activityBloc = Provider.of<ActivityBloc>(context, listen: false);
      if (activityBloc.state != ActivityBlocState.loaded) {
        activityBloc.getActivities();
      } else {
        // If already loaded, mark first load as complete
        _isFirstLoad = false;
      }
    });
  }

  // Filter activities and sort by date (most recent first)
  List<ActivityModel> _getRecentActivities(List<ActivityModel> allActivities) {
    if (allActivities.isEmpty) return [];

    // Create a copy of the list to sort
    final sortedActivities = List<ActivityModel>.from(allActivities);
    
    // Sort by date (newest first)
    sortedActivities.sort((a, b) {
      final dateA = a.activityDate ?? DateTime(1970);
      final dateB = b.activityDate ?? DateTime(1970);
      return dateB.compareTo(dateA);
    });
    
    // Take most recent activities (limit to 4 for grid)
    return sortedActivities.take(4).toList();
  }

  // Get formatted day for display
  String _getFormattedDay(DateTime? date) {
    if (date == null) return 'N/A';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final activityDate = DateTime(date.year, date.month, date.day);
    
    if (activityDate.isAtSameMomentAs(today)) {
      return 'TODAY';
    } else if (activityDate.isAtSameMomentAs(yesterday)) {
      return 'YESTERDAY';
    } else {
      // Return day name for other days
      return DateFormat('EEEE').format(date).toUpperCase();
    }
  }

  // Estimate steps from distance if not available
  int _estimateSteps(ActivityModel activity) {
    // If steps available in locationData, use it
    if (activity.locationData != null && 
        activity.locationData!.containsKey('steps') && 
        activity.locationData!['steps'] is int) {
      return activity.locationData!['steps'] as int;
    }
    
    // Otherwise estimate from distance (1 km ≈ 1300 steps)
    final distance = activity.distanceKm ?? 0;
    return (distance * 1300).round();
  }

  // Navigate to all history activities page
  void _navigateToAllHistoryActivities() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AllHistoryActivitiesPage(),
      ),
    );
  }

  // Widget for empty state
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_run,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No Activities Yet',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Record your workout activities\nto earn coins!',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget for showing error state with friendly message
  Widget _buildErrorState(String errorMessage, VoidCallback onRetry) {
    // Check if error message indicates null data (which actually means no data)
    bool isNullDataError = errorMessage.contains("type 'Null' is not a subtype of type 'List<dynamic>'") ||
                          errorMessage.contains("Error parsing response");
    
    if (isNullDataError) {
      // If it's a null data error, show empty state instead
      return _buildEmptyState(context);
    }
    
    // For other errors, show actual error state
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sync_problem,
            size: 64,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to Load Activities',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'There was an issue loading your activities.\nPlease try again.',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: orangeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          if (errorMessage.isNotEmpty && !isNullDataError)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Details: $errorMessage',
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget for showing loading state with shimmer effect
  Widget _buildLoadingState() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _ShimmerHistoryItem();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive grid
    final screenWidth = MediaQuery.of(context).size.width;
    final childAspectRatio = screenWidth < 360 ? 0.75 : 0.8;
    
    return Consumer<ActivityBloc>(
      builder: (context, activityBloc, child) {
        // Detect if this is a "no data" error (which actually means no data)
        bool isNullDataError = activityBloc.state == ActivityBlocState.error && 
                              (activityBloc.errorMessage.contains("type 'Null' is not a subtype of type 'List<dynamic>'") ||
                               activityBloc.errorMessage.contains("Error parsing response"));
        
        // If it's a null data error, treat it as loaded but with empty data
        final effectiveState = isNullDataError ? ActivityBlocState.loaded : activityBloc.state;
        
        // Update first load state
        if (effectiveState == ActivityBlocState.loaded && _isFirstLoad) {
          _isFirstLoad = false;
        }
        
        final isLoading = effectiveState == ActivityBlocState.loading;
        final hasError = effectiveState == ActivityBlocState.error;
        
        // Get recent activities
        final recentActivities = _getRecentActivities(activityBloc.activities);
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'HISTORY ACTIVITIES', 
                    style: blackTextStyle.copyWith(
                      fontWeight: semiBold, 
                      fontSize: screenWidth < 360 ? 14 : 16
                    )
                  ),
                  if (recentActivities.isNotEmpty)
                    TextButton(
                      onPressed: _navigateToAllHistoryActivities, // Use the navigation method
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'View All',
                        style: orangeTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: medium,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            if (isLoading && _isFirstLoad)
              SizedBox(
                height: 400,
                child: _buildLoadingState(),
              )
            else if (hasError)
              SizedBox(
                height: 300,
                child: _buildErrorState(
                  activityBloc.errorMessage,
                  () => activityBloc.getActivities(),
                ),
              )
            else if (recentActivities.isEmpty || isNullDataError)
              SizedBox(
                height: 300,
                child: _buildEmptyState(context),
              )
            else
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: childAspectRatio,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentActivities.length,
                itemBuilder: (context, index) {
                  final activity = recentActivities[index];
                  
                  // Alternate background colors - orange for items at index 0 and 3
                  final bgColor = (index == 0 || index == 3) ? orangeColor : Colors.white;
                  
                  // Calculate steps
                  final steps = _estimateSteps(activity);
                  
                  // Get title from notes or use a default
                  final title = activity.notes ?? 'Activity';
                  
                  return GestureDetector(
                    onTap: () {
                      // Navigate to activity detail page when tapping on an activity
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivityDetailPage(activity: activity),
                        ),
                      );
                    },
                    child: HistoryActivityItem(
                      day: _getFormattedDay(activity.activityDate),
                      activity: activity.activityType.toUpperCase(),
                      distance: activity.distanceKm ?? 0,
                      duration: activity.durationMinutes,
                      title: title,
                      steps: steps,
                      bgColor: bgColor,
                    ),
                  );
                },
              ),
            
            // Show loading indicator at bottom when refreshing data
            if (isLoading && !_isFirstLoad)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 24, 
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(orangeColor),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// Shimmer effect for loading state
class _ShimmerHistoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shimmer effect for each content block
          for (int i = 0; i < 5; i++)
            Padding(
              padding: EdgeInsets.fromLTRB(
                12, 
                i == 0 ? 16 : 8, 
                12, 
                i == 4 ? 16 : 8
              ),
              child: Container(
                height: i == 2 ? 24 : 12,
                width: i % 2 == 0 ? double.infinity : 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 12,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 12,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
