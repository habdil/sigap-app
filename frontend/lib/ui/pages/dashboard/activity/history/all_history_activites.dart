import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/activites/overview_activites/history_activity_item.dart';
import 'package:frontend/models/activity_model.dart';
import 'package:frontend/blocs/activity_bloc.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:frontend/ui/pages/dashboard/activity/history/activity_detail_page.dart';

class AllHistoryActivitiesPage extends StatefulWidget {
  const AllHistoryActivitiesPage({Key? key}) : super(key: key);

  @override
  State<AllHistoryActivitiesPage> createState() => _AllHistoryActivitiesPageState();
}

class _AllHistoryActivitiesPageState extends State<AllHistoryActivitiesPage> {
  // Filter and sort options
  String _selectedFilter = 'All';
  String _selectedSort = 'Newest';
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  
  // Activity type options for filtering
  final List<String> _activityTypes = ['All', 'Running', 'Walking', 'Cycling', 'Yoga', 'Swimming', 'Hiking'];
  
  // Sort options
  final List<String> _sortOptions = ['Newest', 'Oldest', 'Longest Duration', 'Shortest Duration', 'Longest Distance', 'Shortest Distance'];
  
  @override
  void initState() {
    super.initState();
    _loadActivities();
  }
  
  Future<void> _loadActivities() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });
    
    try {
      final activityBloc = Provider.of<ActivityBloc>(context, listen: false);
      await activityBloc.getActivities();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }
  
  // Filter activities based on selected filter
  List<ActivityModel> _getFilteredActivities(List<ActivityModel> allActivities) {
    if (_selectedFilter == 'All') {
      return allActivities;
    }
    
    return allActivities.where((activity) {
      return activity.activityType.toLowerCase() == _selectedFilter.toLowerCase();
    }).toList();
  }
  
  // Sort activities based on selected sort option
  List<ActivityModel> _getSortedActivities(List<ActivityModel> filteredActivities) {
    switch (_selectedSort) {
      case 'Newest':
        filteredActivities.sort((a, b) {
          final dateA = a.activityDate ?? DateTime(1970);
          final dateB = b.activityDate ?? DateTime(1970);
          return dateB.compareTo(dateA);
        });
        break;
      case 'Oldest':
        filteredActivities.sort((a, b) {
          final dateA = a.activityDate ?? DateTime(1970);
          final dateB = b.activityDate ?? DateTime(1970);
          return dateA.compareTo(dateB);
        });
        break;
      case 'Longest Duration':
        filteredActivities.sort((a, b) => (b.durationMinutes).compareTo(a.durationMinutes));
        break;
      case 'Shortest Duration':
        filteredActivities.sort((a, b) => (a.durationMinutes).compareTo(b.durationMinutes));
        break;
      case 'Longest Distance':
        filteredActivities.sort((a, b) => (b.distanceKm ?? 0).compareTo(a.distanceKm ?? 0));
        break;
      case 'Shortest Distance':
        filteredActivities.sort((a, b) => (a.distanceKm ?? 0).compareTo(b.distanceKm ?? 0));
        break;
    }
    
    return filteredActivities;
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
      // For activities more than a day old, show the date
      return DateFormat('dd MMM').format(date).toUpperCase();
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
  
  // Get background color based on activity type
  Color _getActivityColor(String activityType, int index) {
    // Alternate colors for better visual separation
    if (index % 4 == 0 || index % 4 == 3) {
      return orangeColor;
    }
    
    // For specific activity types
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
        return Colors.white;
    }
  }
  
  // Build filter chips
  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _activityTypes.length,
        itemBuilder: (context, index) {
          final type = _activityTypes[index];
          final isSelected = _selectedFilter == type;
          
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 16 : 8,
              right: index == _activityTypes.length - 1 ? 16 : 0,
            ),
            child: FilterChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = type;
                });
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: orangeColor.withOpacity(0.2),
              checkmarkColor: orangeColor,
              labelStyle: TextStyle(
                color: isSelected ? orangeColor : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? orangeColor : Colors.transparent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  // Build sort dropdown
  Widget _buildSortDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Sort by: ',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSort,
                  icon: const Icon(Icons.arrow_drop_down),
                  isExpanded: true,
                  style: blackTextStyle.copyWith(fontSize: 14),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedSort = newValue;
                      });
                    }
                  },
                  items: _sortOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Build empty state
  Widget _buildEmptyState() {
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
            'No Activities Found',
            style: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilter != 'All' 
                ? 'Try changing your filter or add a new ${_selectedFilter.toLowerCase()} activity'
                : 'Record your workout activities to earn coins!',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to add activity page or reset filters
              if (_selectedFilter != 'All') {
                setState(() {
                  _selectedFilter = 'All';
                });
              } else {
                Navigator.pop(context);
              }
            },
            icon: Icon(_selectedFilter != 'All' ? Icons.filter_list : Icons.add),
            label: Text(_selectedFilter != 'All' ? 'Reset Filters' : 'Add Activity'),
            style: ElevatedButton.styleFrom(
              backgroundColor: orangeColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Build error state
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to Load Activities',
            style: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'There was an error loading your activities. Please try again.',
              style: blackTextStyle.copyWith(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadActivities,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: orangeColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Error details: $_errorMessage',
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
  
  // Build loading state
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(orangeColor),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading Activities...',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: medium,
            ),
          ),
        ],
      ),
    );
  }
  
  // Build activity grid
  Widget _buildActivityGrid(List<ActivityModel> activities) {
    // Get screen dimensions for responsive grid
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    // Calculate grid properties
    final crossAxisCount = screenWidth > 600 ? 3 : 2;
    final childAspectRatio = isSmallScreen ? 0.75 : 0.8;
    final horizontalPadding = 16.0;
    final spacing = 12.0;
    
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        
        // Get background color based on activity type and index
        final bgColor = _getActivityColor(activity.activityType, index);
        
        // Calculate steps
        final steps = _estimateSteps(activity);
        
        // Get title from notes or use a default
        final title = activity.notes ?? '${activity.activityType} Activity';
        
        return GestureDetector(
          onTap: () {
            // Navigate to activity detail page
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
    );
  }
  
  // Build activity list with month headers
  Widget _buildActivityListWithHeaders(List<ActivityModel> activities) {
    // Group activities by month
    final Map<String, List<ActivityModel>> groupedActivities = {};
    
    for (final activity in activities) {
      if (activity.activityDate != null) {
        final monthYear = DateFormat('MMMM yyyy').format(activity.activityDate!);
        if (!groupedActivities.containsKey(monthYear)) {
          groupedActivities[monthYear] = [];
        }
        groupedActivities[monthYear]!.add(activity);
      }
    }
    
    // Sort the keys (months) in descending order
    final sortedMonths = groupedActivities.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('MMMM yyyy').parse(a);
        final dateB = DateFormat('MMMM yyyy').parse(b);
        return dateB.compareTo(dateA);
      });
    
    // Get screen dimensions for responsive grid
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    // Calculate grid properties
    final crossAxisCount = screenWidth > 600 ? 3 : 2;
    final childAspectRatio = isSmallScreen ? 0.75 : 0.8;
    final horizontalPadding = 16.0;
    final spacing = 12.0;
    
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: sortedMonths.length,
      itemBuilder: (context, monthIndex) {
        final month = sortedMonths[monthIndex];
        final monthActivities = groupedActivities[month]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month header
            Padding(
              padding: EdgeInsets.fromLTRB(16, monthIndex == 0 ? 16 : 24, 16, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: orangeColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      month,
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${monthActivities.length} activities)',
                    style: greyTextStyle.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Grid for this month's activities
            GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              itemCount: monthActivities.length,
              itemBuilder: (context, index) {
                final activity = monthActivities[index];
                
                // Get background color based on activity type and index
                final bgColor = _getActivityColor(activity.activityType, index);
                
                // Calculate steps
                final steps = _estimateSteps(activity);
                
                // Get title from notes or use a default
                final title = activity.notes ?? '${activity.activityType} Activity';
                
                return GestureDetector(
                  onTap: () {
                    // Navigate to activity detail page
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
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Activity History',
          style: blackTextStyle.copyWith(
            fontWeight: semiBold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadActivities,
          ),
        ],
      ),
      body: Consumer<ActivityBloc>(
        builder: (context, activityBloc, child) {
          if (_isLoading) {
            return _buildLoadingState();
          }
          
          if (_hasError) {
            return _buildErrorState();
          }
          
          // Get filtered and sorted activities
          final allActivities = activityBloc.activities;
          final filteredActivities = _getFilteredActivities(allActivities);
          final sortedActivities = _getSortedActivities(filteredActivities);
          
          return Column(
            children: [
              // Filter chips
              _buildFilterChips(),
              
              // Sort dropdown
              const SizedBox(height: 8),
              _buildSortDropdown(),
              const SizedBox(height: 16),
              
              // Activity count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '${sortedActivities.length} Activities',
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: semiBold,
                      ),
                    ),
                    const Spacer(),
                    // Toggle between grid and list with headers view
                    IconButton(
                      icon: const Icon(Icons.calendar_month, size: 20),
                      onPressed: () {
                        // Toggle view mode (not implemented in this version)
                      },
                      color: orangeColor,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              // Divider
              Divider(color: Colors.grey.shade200, thickness: 1),
              
              // Activities grid or empty state
              Expanded(
                child: sortedActivities.isEmpty
                    ? _buildEmptyState()
                    : _buildActivityListWithHeaders(sortedActivities),
              ),
            ],
          );
        },
      ),
    );
  }
}