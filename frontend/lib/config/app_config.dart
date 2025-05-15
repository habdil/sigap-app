import 'package:flutter/foundation.dart';

enum Environment { dev, staging, prod }

class AppConfig {
  final String apiBaseUrl;
  final Environment environment;
  final int timeout;

  AppConfig._({
    required this.apiBaseUrl,
    required this.environment,
    this.timeout = 60,
  });

  factory AppConfig.development() {
    return AppConfig._(
      apiBaseUrl: 'http://192.168.1.16:3000/api',
      environment: Environment.dev,
    );
  }

  factory AppConfig.staging() {
    return AppConfig._(
      apiBaseUrl: 'http://69.62.82.146:3000/api',
      environment: Environment.staging,
    );
  }

  factory AppConfig.production() {
    return AppConfig._(
      apiBaseUrl: 'http://69.62.82.146:3000/api',
      environment: Environment.prod,
    );
  }

  static late AppConfig _instance;

  static void initialize() {
    // Ini bisa dikembangkan untuk mendeteksi environment dari build flags
    // atau environment variables saat build
    if (kReleaseMode) {
      _instance = AppConfig.production();
    } else if (const bool.fromEnvironment('STAGING')) {
      _instance = AppConfig.staging();
    } else {
      _instance = AppConfig.development();
    }
  }

  static AppConfig get instance {
    return _instance;
  }
}
