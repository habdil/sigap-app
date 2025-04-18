import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/user_model.dart';

class StorageService {
  static const String userKey = 'user_data';
  
  // Save user data
  static Future<bool> saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(user.toJson());
      return await prefs.setString(userKey, userData);
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }
  
  // Get user data
  static Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(userKey);
      
      if (userData != null) {
        return User.fromJson(json.decode(userData));
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
  
  // Clear user data
  static Future<bool> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(userKey);
    } catch (e) {
      print('Error clearing user data: $e');
      return false;
    }
  }
}