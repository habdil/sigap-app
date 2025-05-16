import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/models/activity_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class ActivityDetailPage extends StatelessWidget {
  final ActivityModel activity;
  
  const ActivityDetailPage({
    Key? key,
    required this.activity,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Format date and time
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    final formattedDate = activity.activityDate != null 
        ? dateFormat.format(activity.activityDate!) 
        : 'Unknown Date';
    final formattedTime = activity.activityDate != null 
        ? timeFormat.format(activity.activityDate!) 
        : 'Unknown Time';
    
    // Calculate pace
    final pace = activity.avgPace ?? 0;
    final paceMinutes = pace.floor();
    final paceSeconds = ((pace - paceMinutes) * 60).round();
    final formattedPace = '$paceMinutes:${paceSeconds.toString().padLeft(2, '0')} /km';
    
    // Calculate calories per minute
    final caloriesPerMinute = (activity.caloriesBurned != null && activity.durationMinutes > 0) 
        ? (activity.caloriesBurned! / activity.durationMinutes).toStringAsFixed(1) 
        : '0';
    
    // Format duration
    final hours = activity.durationMinutes ~/ 60;
    final minutes = activity.durationMinutes % 60;
    final formattedDuration = hours > 0 
        ? '$hours hr ${minutes.toString().padLeft(2, '0')} min' 
        : '$minutes min';
    
    // Estimate steps if not available
    int steps = 0;
    if (activity.locationData != null && 
        activity.locationData!.containsKey('steps') && 
        activity.locationData!['steps'] is int) {
      steps = activity.locationData!['steps'] as int;
    } else {
      // Estimate from distance (1 km ≈ 1300 steps)
      final distance = activity.distanceKm ?? 0;
      steps = (distance * 1300).round();
    }
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: orangeColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                activity.activityType,
                style: whiteTextStyle.copyWith(
                  fontWeight: semiBold,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Activity type background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _getActivityColor(activity.activityType),
                          orangeColor,
                        ],
                      ),
                    ),
                  ),
                  
                  // Activity icon
                  Center(
                    child: Icon(
                      _getActivityIcon(activity.activityType),
                      size: 80,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  
                  // Gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  // Share activity functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing activity...')),
                  );
                },
              ),
            ],
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and time
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: greyColor),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: greyTextStyle.copyWith(fontSize: 14),
                      ),
                      const Spacer(),
                      Icon(Icons.access_time, size: 16, color: greyColor),
                      const SizedBox(width: 8),
                      Text(
                        formattedTime,
                        style: greyTextStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                
                // Weather if available
                if (activity.weatherCondition != null && activity.weatherCondition!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        Icon(
                          _getWeatherIcon(activity.weatherCondition!),
                          size: 16,
                          color: greyColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          activity.weatherCondition!,
                          style: greyTextStyle.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                
                // Activity title/notes
                if (activity.notes != null && activity.notes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      activity.notes!,
                      style: blackTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                
                // Main stats cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Duration card
                      Expanded(
                        child: _buildStatCard(
                          title: 'Duration',
                          value: formattedDuration,
                          icon: Icons.timer,
                          color: orangeColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Distance card
                      Expanded(
                        child: _buildStatCard(
                          title: 'Distance',
                          value: '${activity.distanceKm?.toStringAsFixed(2) ?? '0'} km',
                          icon: Icons.straighten,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Secondary stats cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Pace card
                      Expanded(
                        child: _buildStatCard(
                          title: 'Avg. Pace',
                          value: formattedPace,
                          icon: Icons.speed,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Calories card
                      Expanded(
                        child: _buildStatCard(
                          title: 'Calories',
                          value: '${activity.caloriesBurned} kcal',
                          icon: Icons.local_fire_department,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Additional stats section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'ACTIVITY DETAILS',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Steps
                _buildDetailRow(
                  icon: Icons.directions_walk,
                  title: 'Steps',
                  value: '$steps steps',
                ),
                
                // Heart rate if available
                if (activity.heartRateAvg != null && activity.heartRateAvg! > 0)
                  _buildDetailRow(
                    icon: Icons.favorite,
                    title: 'Avg. Heart Rate',
                    value: '${activity.heartRateAvg} bpm',
                  ),
                
                // Calories per minute
                _buildDetailRow(
                  icon: Icons.local_fire_department,
                  title: 'Calories Burn Rate',
                  value: '$caloriesPerMinute kcal/min',
                ),
                
                // Coins earned
                _buildDetailRow(
                  icon: Icons.monetization_on,
                  title: 'Coins Earned',
                  value: '${activity.coinsEarned} coins',
                  valueColor: orangeColor,
                ),
                
                const SizedBox(height: 24),
                
                // Map section header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'ROUTE MAP',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Map placeholder
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Route map will be displayed here',
                            style: greyTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Delete button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton.icon(
                    onPressed: () {
                      // Show delete confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            'Delete Activity',
                            style: blackTextStyle.copyWith(fontWeight: semiBold),
                          ),
                          content: Text(
                            'Are you sure you want to delete this activity? This action cannot be undone.',
                            style: blackTextStyle,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel', style: greyTextStyle),
                            ),
                            TextButton(
                              onPressed: () {
                                // Delete activity functionality
                                Navigator.pop(context); // Close dialog
                                Navigator.pop(context); // Return to previous screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Activity deleted')),
                                );
                              },
                              child: Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: Text(
                      'Delete Activity',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Build stat card widget
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: greyTextStyle.copyWith(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: semiBold,
            ),
          ),
        ],
      ),
    );
  }
  
  // Build detail row widget
  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: greyColor),
          const SizedBox(width: 16),
          Text(
            title,
            style: blackTextStyle.copyWith(fontSize: 14),
          ),
          const Spacer(),
          Text(
            value,
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
  
  // Get color based on activity type
  Color _getActivityColor(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'running':
        return Colors.blue;
      case 'walking':
        return Colors.green;
      case 'cycling':
        return Colors.orange;
      case 'yoga':
        return Colors.purple;
      case 'swimming':
        return Colors.cyan;
      case 'hiking':
        return Colors.brown;
      default:
        return orangeColor;
    }
  }
  
  // Get icon based on activity type
  IconData _getActivityIcon(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'running':
        return Icons.directions_run;
      case 'walking':
        return Icons.directions_walk;
      case 'cycling':
        return Icons.directions_bike;
      case 'yoga':
        return Icons.self_improvement;
      case 'swimming':
        return Icons.pool;
      case 'hiking':
        return Icons.terrain;
      default:
        return Icons.fitness_center;
    }
  }
  
  // Get weather icon based on condition
  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.water_drop;
      case 'snowy':
        return Icons.ac_unit;
      case 'stormy':
        return Icons.thunderstorm;
      default:
        return Icons.cloud;
    }
  }
}
