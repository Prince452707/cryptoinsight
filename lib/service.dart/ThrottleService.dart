

class ThrottleService {
  static final Map<String, DateTime> _lastRequestTimes = {};
  static const Duration throttleDuration = Duration(seconds: 1);

  static Future<void> throttle(String key) async {
    final now = DateTime.now();
    final lastRequestTime = _lastRequestTimes[key];
    if (lastRequestTime != null) {
      final timeSinceLastRequest = now.difference(lastRequestTime);
      if (timeSinceLastRequest < throttleDuration) {
        await Future.delayed(throttleDuration - timeSinceLastRequest);
      }
    }
    _lastRequestTimes[key] = DateTime.now();
  }
}