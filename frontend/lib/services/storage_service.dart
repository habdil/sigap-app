// lib\services\storage_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/user_model.dart';

class StorageService {
  static const String userKey = 'user_data';
  static const String tokenKey = 'auth_token';
  
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
  
  // Save authentication token
  static Future<bool> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(tokenKey, token);
    } catch (e) {
      print('Error saving token: $e');
      return false;
    }
  }
  
  // Get authentication token
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(tokenKey);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }
  
  // Clear authentication token
  static Future<bool> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(tokenKey);
    } catch (e) {
      print('Error clearing token: $e');
      return false;
    }
  }
  
  // Clear all stored data (for logout)
  static Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(userKey);
      await prefs.remove(tokenKey);
      // Add any other keys that need to be cleared
      return true;
    } catch (e) {
      print('Error clearing all data: $e');
      return false;
    }
  }
}