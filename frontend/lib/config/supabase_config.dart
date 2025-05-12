import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://kpljxrkjdosvzhecjwxr.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtwbGp4cmtqZG9zdnpoZWNqd3hyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ5Njc2MjIsImV4cCI6MjA2MDU0MzYyMn0.hIAI-LNv2FUwqYE9Ae9H0m-0MboAkITD910wXAlYxuk',
      debug: true,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}