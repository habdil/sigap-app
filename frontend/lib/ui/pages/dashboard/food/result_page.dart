// lib/ui/pages/dashboard/food/result_page.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/blocs/food_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/ui/widgets/food/scan_food/loading_view.dart';
import 'package:frontend/ui/widgets/food/scan_food/error_view.dart';
import 'package:frontend/ui/widgets/food/scan_food/result_view.dart';
import 'package:frontend/ui/pages/dashboard/food/food_page.dart';
import 'package:frontend/shared/notification.dart';
import 'dart:async';

class FoodResultPage extends StatefulWidget {
  final int foodLogId;
  final String imageData;
  
  const FoodResultPage({
    super.key,
    required this.foodLogId,
    required this.imageData,
  });

  @override
  State<FoodResultPage> createState() => _FoodResultPageState();
}

class _FoodResultPageState extends State<FoodResultPage> {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  Map<String, Map<String, dynamic>>? _analysisData;
  Timer? _timeoutTimer;
  StreamSubscription? _blocSubscription;
  
  /// Constant for analysis timeout (in seconds)
  static const int _analysisTimeoutDuration = 45; // Extended timeout for slower connections
  
  @override
  void initState() {
    super.initState();
    
    // Start analysis process with slight delay to allow UI rendering
    Future.microtask(() => _startAnalysis());
    
    // Set timeout
    _setAnalysisTimeout();
  }
  
  void _setAnalysisTimeout() {
    // Cancel previous timer if it exists
    _timeoutTimer?.cancel();
    
    // Set new timeout
    _timeoutTimer = Timer(Duration(seconds: _analysisTimeoutDuration), () {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Analysis is taking too long. Please check your internet connection and try again.';
      });
      
      // Show error notification
      context.showErrorNotification(
        title: 'Timeout',
        message: 'Analysis process is taking too long. Please try again later.',
      );
    });
  }
  
  void _startAnalysis() {
    try {
      // Cancel existing subscription if it exists
      _blocSubscription?.cancel();
      
      // Start new subscription
      _blocSubscription = BlocProvider.of<FoodBloc>(context).stream.listen(
        (state) {
          if (!mounted) return;
          
          if (state is FoodAnalyzed) {
            // Cancel timeout timer
            _timeoutTimer?.cancel();
            _timeoutTimer = null;
            
            try {
              final nutrientData = state.analysis.toNutrientMap();
              
              setState(() {
                _analysisData = nutrientData;
                _isLoading = false;
                _hasError = false;
              });
            } catch (e) {
              setState(() {
                _isLoading = false;
                _hasError = true;
                _errorMessage = 'Error processing results: ${e.toString()}';
              });
              
              // Show error notification
              context.showErrorNotification(
                title: 'Analysis Error',
                message: 'An error occurred while processing the results.',
              );
            }
          } else if (state is FoodError) {
            // Cancel timeout timer
            _timeoutTimer?.cancel();
            _timeoutTimer = null;
            
            setState(() {
              _isLoading = false;
              _hasError = true;
              _errorMessage = state.message.isNotEmpty
                  ? state.message
                  : 'An error occurred during analysis.';
            });
            
            // Show error notification
            context.showErrorNotification(
              title: 'Error',
              message: _errorMessage,
            );
          }
        },
        onError: (error) {
          if (!mounted) return;
          
          // Cancel timeout timer
          _timeoutTimer?.cancel();
          _timeoutTimer = null;
          
          setState(() {
            _isLoading = false;
            _hasError = true;
            _errorMessage = 'An error occurred: ${error.toString()}';
          });
          
          // Show error notification
          context.showErrorNotification(
            title: 'Unexpected Error',
            message: 'An unexpected error occurred.',
          );
        },
      );
      
      // Send event to start analysis
      context.read<FoodBloc>().add(
        AnalyzeFoodWithImage(
          foodLogId: widget.foodLogId,
          imageData: widget.imageData,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Cannot start analysis: ${e.toString()}';
      });
      
      // Show error notification
      context.showErrorNotification(
        title: 'Error',
        message: 'Unable to start food analysis.',
      );
    }
  }
  
  void _cancelAnalysis() {
    // Clean up resources
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    
    _blocSubscription?.cancel();
    _blocSubscription = null;
    
    // Return to previous screen
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
  
  void _tryAgain() {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });
    
    // Start analysis again
    _startAnalysis();
    
    // Set new timeout
    _setAnalysisTimeout();
  }
  
  void _navigateToFoodPage() {
    // Clean up resources
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    
    _blocSubscription?.cancel();
    _blocSubscription = null;
    
    // Navigate to FoodPage and replace all previous routes
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const FoodPage()),
        (route) => false,  // Remove all previous routes
      );
    }
  }
  
  @override
  void dispose() {
    // Cancel timers and subscriptions
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    
    _blocSubscription?.cancel();
    _blocSubscription = null;
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Cancel any ongoing operations before popping
        _cancelAnalysis();
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: _cancelAnalysis,
          ),
          title: _isLoading 
              ? null 
              : Text(
                  'Food Analysis', 
                  style: blackTextStyle.copyWith(fontWeight: semiBold),
                ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: _buildContent(),
        ),
      ),
    );
  }
  
  Widget _buildContent() {
    if (_isLoading) {
      return LoadingView(onCancel: _cancelAnalysis);
    } else if (_hasError) {
      return ErrorView(
        errorMessage: _errorMessage,
        onTryAgain: _tryAgain,
      );
    } else if (_analysisData != null) {
      return ResultView(
        analysisData: _analysisData!,
        onScanAgain: () => Navigator.of(context).pop(),
        onGoToFoodPage: _navigateToFoodPage,
      );
    } else {
      // Fallback for unexpected conditions
      return _buildFallbackView();
    }
  }
  
  Widget _buildFallbackView() {
    return Container(
      color: whiteColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              color: greyColor,
              size: 50,
            ),
            const SizedBox(height: 16),
            Text(
              'Analysis data not available',
              style: blackTextStyle.copyWith(
                fontSize: 18,
                fontWeight: medium,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    foregroundColor: whiteColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _tryAgain,
                  child: Text(
                    'Try Again',
                    style: whiteTextStyle.copyWith(fontWeight: medium),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor,
                    foregroundColor: whiteColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _navigateToFoodPage,
                  child: Text(
                    'Food Diary',
                    style: whiteTextStyle.copyWith(fontWeight: medium),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}