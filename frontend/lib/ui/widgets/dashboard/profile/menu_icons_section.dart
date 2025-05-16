// frontend/lib/ui/widgets/dashboard/profile/menu_icons_section.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/blocs/activity_bloc.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/activity_model.dart';

class MenuIconsSection extends StatefulWidget {
  final VoidCallback? onRefresh;
  
  const MenuIconsSection({
    super.key,
    this.onRefresh,
  });

  @override
  State<MenuIconsSection> createState() => _MenuIconsSectionState();
}

class _MenuIconsSectionState extends State<MenuIconsSection> {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  
  // Stats data
  String _caloriesBurned = '0';
  String _distanceRun = '0';
  String _activitiesCount = '0';
  
  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    
    try {
      final activityBloc = Provider.of<ActivityBloc>(context, listen: false);
      
      // Fetch activities
      await activityBloc.getActivities();
      
      if (activityBloc.state == ActivityBlocState.error) {
        setState(() {
          _hasError = true;
          _errorMessage = activityBloc.errorMessage;
          _isLoading = false;
        });
        return;
      }
      
      if (mounted) {
        // Calculate this week's data
        final thisWeekActivities = _getThisWeekActivities(activityBloc.activities);
        
        setState(() {
          // Calculate total calories burned (for all time)
          _caloriesBurned = '${activityBloc.getTotalCaloriesBurned()} cal';
          
          // Calculate distance run this week (in km)
          final thisWeekDistance = _calculateTotalDistance(thisWeekActivities);
          _distanceRun = '${thisWeekDistance.toStringAsFixed(1)}km\nthis week';
          
          // Get activities count (for all time)
          _activitiesCount = '${activityBloc.activities.length}\nactivities';
          
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to load dashboard data';
          _isLoading = false;
        });
      }
      print('Error fetching dashboard data: $e');
    }
  }
  
  // Helper method to get activities from this week only
  List<ActivityModel> _getThisWeekActivities(List<ActivityModel> allActivities) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    
    return allActivities.where((activity) {
      if (activity.activityDate == null) return false;
      return activity.activityDate!.isAfter(startDate);
    }).toList();
  }
  
  // Helper method to calculate total distance from a list of activities
  double _calculateTotalDistance(List<ActivityModel> activities) {
    return activities
        .where((activity) => activity.distanceKm != null)
        .fold(0.0, (sum, activity) => sum + (activity.distanceKm ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _fetchData();
        if (widget.onRefresh != null) {
          widget.onRefresh!();
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildContent(),
        ),
      ),
    );
  }
  
  Widget _buildContent() {
    if (_isLoading) {
      return const SizedBox(
        height: 80,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_hasError) {
      return SizedBox(
        height: 80,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Failed to load data',
                style: blackTextStyle.copyWith(fontSize: 12),
              ),
              TextButton(
                onPressed: _fetchData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconMenu(_caloriesBurned, 'assets/icn_eat.png', 'Calories\nBurned'),
        _buildVerticalDivider(),
        _buildIconMenu(_distanceRun, 'assets/icn_run.png', null),
        _buildVerticalDivider(),
        _buildIconMenu(_activitiesCount, Icons.directions_run, 'Total'),
      ],
    );
  }

  Widget _buildIconMenu(String value, dynamic icon, [String? label]) {
    return Column(
      children: [
        icon is IconData
            ? Icon(
                icon,
                color: orangeColor,
                size: 24,
              )
            : Image.asset(
                icon,
                width: 24,
                height: 24,
                color: orangeColor,
              ),
        const SizedBox(height: 8),
        Text(
          label != null ? '$label\n$value' : value,
          style: blackTextStyle.copyWith(
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade300,
    );
  }
}