import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String prefix = 'api_cache_';
  static const Duration defaultCacheDuration = Duration(minutes: 15);

  static Future<void> setCache(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$prefix$key', value);
    await prefs.setInt('${prefix}${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  static Future<String?> getCache(String key, {Duration? maxAge}) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('$prefix$key');
    final timestamp = prefs.getInt('${prefix}${key}_timestamp');
    
    if (value != null && timestamp != null) {
      final age = DateTime.now().millisecondsSinceEpoch - timestamp;
      if (age < (maxAge ?? defaultCacheDuration).inMilliseconds) {
        return value;
      }
    }
    return null;
  }
}