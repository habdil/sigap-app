// lib/blocs/coin_bloc.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/coin_model.dart';
import 'package:frontend/models/coin_transaction_model.dart';
import 'package:frontend/services/coin_service.dart';

enum CoinBlocState {
  initial,
  loading,
  loaded,
  transactionsLoading,
  transactionsLoaded,
  spending,
  error,
}

class CoinBloc extends ChangeNotifier {
  CoinBlocState _state = CoinBlocState.initial;
  CoinModel? _coinData;
  List<CoinTransactionModel> _transactions = [];
  String _errorMessage = '';
  bool _isSpendingCoins = false;

  // Getters
  CoinBlocState get state => _state;
  CoinModel? get coinData => _coinData;
  int get totalCoins => _coinData?.totalCoins ?? 0;
  List<CoinTransactionModel> get transactions => _transactions;
  String get errorMessage => _errorMessage;
  bool get isSpendingCoins => _isSpendingCoins;

  // Metode untuk mengambil saldo koin
  Future<void> getCoins() async {
    try {
      print('CoinBloc: Starting getCoins');
      _state = CoinBlocState.loading;
      notifyListeners();

      final result = await CoinService.getCoins();
      
      if (result['success']) {
        _coinData = result['data'];
        _state = CoinBlocState.loaded;
        print('CoinBloc: Successfully loaded coin data: ${_coinData?.totalCoins} coins');
      } else {
        _errorMessage = result['message'];
        _state = CoinBlocState.error;
        print('CoinBloc: Error getting coins: $_errorMessage');
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      _state = CoinBlocState.error;
      print('CoinBloc: Exception in getCoins: $e');
    } finally {
      notifyListeners();
    }
  }

  // Metode untuk mengambil riwayat transaksi
  Future<void> getTransactions() async {
    try {
      print('CoinBloc: Starting getTransactions');
      _state = CoinBlocState.transactionsLoading;
      notifyListeners();

      final result = await CoinService.getTransactions();
      
      if (result['success']) {
        _transactions = result['data'];
        _state = CoinBlocState.transactionsLoaded;
        print('CoinBloc: Successfully loaded ${_transactions.length} transactions');
      } else {
        _errorMessage = result['message'];
        _state = CoinBlocState.error;
        print('CoinBloc: Error getting transactions: $_errorMessage');
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      _state = CoinBlocState.error;
      print('CoinBloc: Exception in getTransactions: $e');
    } finally {
      notifyListeners();
    }
  }

  // Metode untuk menghabiskan koin
  Future<bool> spendCoins(CoinTransactionModel transaction) async {
    try {
      print('CoinBloc: Starting spendCoins for amount: ${transaction.amount}');
      _isSpendingCoins = true;
      _state = CoinBlocState.spending;
      notifyListeners();

      final result = await CoinService.spendCoins(transaction);
      
      if (result['success']) {
        print('CoinBloc: Successfully spent coins');
        // Setelah menghabiskan koin, refresh saldo dan riwayat transaksi
        await getCoins();
        await getTransactions();
        return true;
      } else {
        _errorMessage = result['message'];
        _state = CoinBlocState.error;
        print('CoinBloc: Error spending coins: $_errorMessage');
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      _state = CoinBlocState.error;
      print('CoinBloc: Exception in spendCoins: $e');
      return false;
    } finally {
      _isSpendingCoins = false;
      notifyListeners();
    }
  }

  // lib/blocs/coin_bloc.dart (lanjutan)
  // Method untuk mendapatkan total koin yang diperoleh dari aktivitas
  int getTotalEarnedCoins() {
    return _transactions
        .where((transaction) => 
            transaction.amount > 0 && 
            transaction.transactionType == 'Activity')
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  // Method untuk mendapatkan total koin yang dihabiskan
  int getTotalSpentCoins() {
    return _transactions
        .where((transaction) => transaction.amount < 0)
        .fold(0, (sum, transaction) => sum + transaction.amount.abs());
  }

  // Method untuk mendapatkan transaksi berdasarkan jenis
  List<CoinTransactionModel> getTransactionsByType(String type) {
    return _transactions
        .where((transaction) => transaction.transactionType == type)
        .toList();
  }

  // Reset state ke initial
  void reset() {
    _state = CoinBlocState.initial;
    _coinData = null;
    _transactions = [];
    _errorMessage = '';
    _isSpendingCoins = false;
    notifyListeners();
  }
}