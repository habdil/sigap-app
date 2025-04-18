import 'dart:async';

import 'package:frontend/models/user_model.dart';

class UserBloc {
  // Singleton pattern
  static final UserBloc _instance = UserBloc._internal();
  factory UserBloc() => _instance;
  UserBloc._internal();

  // Stream controller for user data
  final _userController = StreamController<User?>.broadcast();
  
  // Getters for the stream and sink
  Stream<User?> get user => _userController.stream;
  
  // Current user data
  User? _currentUser;
  User? get currentUser => _currentUser;
  
  // Set user data when logged in
  void setUser(User user) {
    _currentUser = user;
    _userController.add(user);
  }
  
  // Clear user data when logged out
  void clearUser() {
    _currentUser = null;
    _userController.add(null);
  }
  
  // Dispose resources
  void dispose() {
    _userController.close();
  }
}