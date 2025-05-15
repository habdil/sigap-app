import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/blocs/food_bloc.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/shared/loading.dart';
import 'package:frontend/shared/navbar.dart';
import 'package:frontend/shared/notification.dart';
import 'package:frontend/models/food_model.dart';
import 'package:frontend/ui/widgets/food/view_details.dart';
import 'package:frontend/ui/widgets/food/history/search_bar.dart';
import 'package:frontend/ui/widgets/food/history/stats_summary.dart';
import 'package:frontend/ui/widgets/food/history/food_logs_list.dart';
import 'package:frontend/ui/widgets/food/history/error_state.dart';
import 'package:frontend/ui/widgets/food/history/filter_dialog.dart';

class AllFoodHistoryPage extends StatefulWidget {
  const AllFoodHistoryPage({super.key});

  @override
  State<AllFoodHistoryPage> createState() => _AllFoodHistoryPageState();
}

class _AllFoodHistoryPageState extends State<AllFoodHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<FoodLog> _allFoodLogs = [];
  List<FoodLog> _filteredFoodLogs = [];
  
  // Filter options
  String _sortBy = 'date'; // 'date', 'name', 'calories'
  bool _sortAscending = false;
  String _filterBy = 'all'; // 'all', 'analyzed', 'not_analyzed'
  
  @override
  void initState() {
    super.initState();
    
    // Fetch food logs when page is loaded
    context.read<FoodBloc>().add(LoadFoodLogs());
    
    // Set up search listener
    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFilters();
    });
  }
  
  void _applyFilters() {
    // Start with all food logs
    List<FoodLog> result = List.from(_allFoodLogs);
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      result = result.where((log) => 
        log.foodName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (log.notes != null && log.notes!.toLowerCase().contains(_searchQuery.toLowerCase()))
      ).toList();
    }
    
    // Apply type filter
    if (_filterBy == 'analyzed') {
      result = result.where((log) => log.analysis != null).toList();
    } else if (_filterBy == 'not_analyzed') {
      result = result.where((log) => log.analysis == null).toList();
    }
    
    // Apply sorting
    result.sort((a, b) {
      if (_sortBy == 'date') {
        final dateA = a.logDate ?? DateTime.now();
        final dateB = b.logDate ?? DateTime.now();
        return _sortAscending
            ? dateA.compareTo(dateB)
            : dateB.compareTo(dateA);
      } else if (_sortBy == 'name') {
        return _sortAscending
            ? a.foodName.compareTo(b.foodName)
            : b.foodName.compareTo(a.foodName);
      } else if (_sortBy == 'calories') {
        final caloriesA = a.analysis?.calories ?? 0;
        final caloriesB = b.analysis?.calories ?? 0;
        return _sortAscending
            ? caloriesA.compareTo(caloriesB)
            : caloriesB.compareTo(caloriesA);
      }
      return 0;
    });
    
    _filteredFoodLogs = result;
  }
  
  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _filterBy = 'all';
      _applyFilters();
    });
  }
  
  void _showFoodDetails(FoodLog foodLog) {
    FoodDetailsView.show(context, foodLog);
  }
  
  void _showFilterDialog(BuildContext context) {
    FilterDialog.show(
      context,
      _sortBy,
      _sortAscending,
      _filterBy,
      (sortBy, sortAscending, filterBy) {
        setState(() {
          _sortBy = sortBy;
          _sortAscending = sortAscending;
          _filterBy = filterBy;
          _applyFilters();
        });
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isPad = screenSize.width > 600;
    
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.5,
        title: Text(
          'Food History',
          style: blackTextStyle.copyWith(
            fontSize: isPad ? 20 : 18,
            fontWeight: semiBold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: blackColor,
            size: isPad ? 24 : 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Filter button
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: blackColor,
              size: isPad ? 24 : 20,
            ),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            FoodSearchBar(
              controller: _searchController,
              searchQuery: _searchQuery,
              isPad: isPad,
            ),
            
            // Stats summary
            StatsSummary(
              allFoodLogs: _allFoodLogs,
              isPad: isPad,
            ),
            
            // Main content with BLoC integration
            Expanded(
              child: BlocConsumer<FoodBloc, FoodState>(
                listener: (context, state) {
                  // Update local list when data is loaded
                  if (state is FoodLoaded) {
                    setState(() {
                      _allFoodLogs = state.foodLogs;
                      _applyFilters();
                    });
                  } else if (state is FoodError) {
                    // Show error notification
                    context.showErrorNotification(
                      title: 'Error',
                      message: state.message,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is FoodLoading && _allFoodLogs.isEmpty) {
                    return const Center(
                      child: ElegantLoading(message: 'Loading food history...'),
                    );
                  } else if (state is FoodError && _allFoodLogs.isEmpty) {
                    return ErrorState(
                      message: state.message,
                      isPad: isPad,
                    );
                  } else {
                    // Show filtered list
                    return FoodLogsList(
                      filteredFoodLogs: _filteredFoodLogs,
                      allFoodLogs: _allFoodLogs,
                      searchQuery: _searchQuery,
                      filterBy: _filterBy,
                      isPad: isPad,
                      onFoodLogTap: _showFoodDetails,
                      onResetFilters: _resetFilters,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(initialIndex: 2),
    );
  }
}