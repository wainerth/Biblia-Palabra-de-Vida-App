class RateLimiter {
  static final Map<String, List<DateTime>> _attempts = {};
  static const int _maxAttempts = 5;
  static const Duration _timeWindow = Duration(minutes: 15);

  static bool isRateLimited(String identifier) {
    _cleanOldAttempts(identifier);
    
    final attempts = _attempts[identifier] ?? [];
    return attempts.length >= _maxAttempts;
  }

  static void recordAttempt(String identifier) {
    final now = DateTime.now();
    if (_attempts[identifier] == null) {
      _attempts[identifier] = [];
    }
    _attempts[identifier]!.add(now);
    _cleanOldAttempts(identifier);
  }

  static void _cleanOldAttempts(String identifier) {
    final now = DateTime.now();
    _attempts[identifier]?.removeWhere((attempt) => 
        now.difference(attempt) > _timeWindow);
  }

  static int getRemainingAttempts(String identifier) {
    _cleanOldAttempts(identifier);
    final attempts = _attempts[identifier] ?? [];
    return _maxAttempts - attempts.length;
  }

  static void resetAttempts(String identifier) {
    _attempts.remove(identifier);
  }
}