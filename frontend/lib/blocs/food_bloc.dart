// lib/blocs/food_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/food_model.dart';
import 'package:frontend/models/food_analysis_model.dart';
import 'package:frontend/services/food_service.dart';

// Events
abstract class FoodEvent {}

class LoadFoodLogs extends FoodEvent {}

class AddFoodLog extends FoodEvent {
  final String foodName;
  final String? notes;
  
  AddFoodLog({required this.foodName, this.notes});
}

class AnalyzeFoodWithImage extends FoodEvent {
  final int foodLogId;
  final String imageData;
  
  AnalyzeFoodWithImage({required this.foodLogId, required this.imageData});
}

// States
abstract class FoodState {}

class FoodInitial extends FoodState {}

class FoodLoading extends FoodState {}

class FoodLoaded extends FoodState {
  final List<FoodLog> foodLogs;
  
  FoodLoaded({required this.foodLogs});
}

class FoodAdded extends FoodState {
  final FoodLog foodLog;
  
  FoodAdded({required this.foodLog});
}

class FoodAnalyzed extends FoodState {
  final FoodAnalysis analysis;
  
  FoodAnalyzed({required this.analysis});
}

class FoodError extends FoodState {
  final String message;
  
  FoodError({required this.message});
}

// Bloc
class FoodBloc extends Bloc<FoodEvent, FoodState> {
  FoodBloc() : super(FoodInitial()) {
    on<LoadFoodLogs>(_onLoadFoodLogs);
    on<AddFoodLog>(_onAddFoodLog);
    on<AnalyzeFoodWithImage>(_onAnalyzeFoodWithImage);
  }

  Future<void> _onLoadFoodLogs(LoadFoodLogs event, Emitter<FoodState> emit) async {
    print('FoodBloc: Processing LoadFoodLogs event');
    emit(FoodLoading());
    
    final result = await FoodService.getFoodLogs();
    
    if (result['success']) {
      print('FoodBloc: Food logs loaded successfully: ${(result['data'] as List).length} logs');
      emit(FoodLoaded(foodLogs: result['data']));
    } else {
      print('FoodBloc: Error loading food logs: ${result['message']}');
      emit(FoodError(message: result['message']));
    }
  }

  Future<void> _onAddFoodLog(AddFoodLog event, Emitter<FoodState> emit) async {
    print('FoodBloc: Processing AddFoodLog event for "${event.foodName}"');
    emit(FoodLoading());
    
    final foodLog = FoodLog(
      foodName: event.foodName,
      notes: event.notes,
    );
    
    final result = await FoodService.addFoodLog(foodLog);
    
    if (result['success']) {
      print('FoodBloc: Food log added successfully with ID: ${result['data'].id}');
      emit(FoodAdded(foodLog: result['data']));
      // Reload food logs after addition
      add(LoadFoodLogs());
    } else {
      print('FoodBloc: Error adding food log: ${result['message']}');
      emit(FoodError(message: result['message']));
    }
  }

  Future<void> _onAnalyzeFoodWithImage(AnalyzeFoodWithImage event, Emitter<FoodState> emit) async {
    print('FoodBloc: Processing AnalyzeFoodWithImage event for food log ID: ${event.foodLogId}');
    emit(FoodLoading());
    
    try {
      print('FoodBloc: Calling food service to analyze image...');
      final result = await FoodService.analyzeFoodWithImage(
        event.foodLogId,
        event.imageData,
      );
      
      print('FoodBloc: Analysis result received, success: ${result['success']}');
      
      if (result['success']) {
        // Perbaikan: tambahkan delay kecil sebelum emitting state untuk menghindari race condition
        await Future.delayed(Duration(milliseconds: 200));
        
        print('FoodBloc: Emitting FoodAnalyzed state with data: ${result['data']}');
        emit(FoodAnalyzed(analysis: result['data']));
        print('FoodBloc: FoodAnalyzed state emitted');
        
        // Reload food logs after analysis to get updated data
        print('FoodBloc: Triggering LoadFoodLogs to refresh data');
        add(LoadFoodLogs());
      } else {
        print('FoodBloc: Emitting FoodError state with message: ${result['message']}');
        emit(FoodError(message: result['message']));
      }
    } catch (e) {
      print('Error in food bloc during analysis: $e');
      emit(FoodError(message: 'Analysis failed: ${e.toString()}'));
    }
  }
}