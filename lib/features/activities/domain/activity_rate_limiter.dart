import 'activity_type.dart';

class ActivityRateLimiter {
  ActivityRateLimiter({
    this.perTypeCooldown = const Duration(milliseconds: 800),
    this.globalCooldown = const Duration(milliseconds: 250),
    this.burstWindow = const Duration(seconds: 3),
    this.maxBurst = 6,
  });

  final Duration perTypeCooldown;
  final Duration globalCooldown;
  final Duration burstWindow;
  final int maxBurst;
  final Map<ActivityType, DateTime> _lastAcceptedByType = {};
  final List<DateTime> _acceptedAttempts = [];

  bool shouldAccept(ActivityType type, {DateTime? now}) {
    final timestamp = now ?? DateTime.now();
    _prune(timestamp);
    final lastForType = _lastAcceptedByType[type];
    if (lastForType != null &&
        timestamp.difference(lastForType) < perTypeCooldown) {
      return false;
    }
    if (_acceptedAttempts.isNotEmpty &&
        timestamp.difference(_acceptedAttempts.last) < globalCooldown) {
      return false;
    }
    if (_acceptedAttempts.length >= maxBurst) return false;
    return true;
  }

  void recordAccepted(ActivityType type, {DateTime? now}) {
    final timestamp = now ?? DateTime.now();
    _prune(timestamp);
    _lastAcceptedByType[type] = timestamp;
    _acceptedAttempts.add(timestamp);
  }

  bool accept(ActivityType type, {DateTime? now}) {
    if (!shouldAccept(type, now: now)) return false;
    recordAccepted(type, now: now);
    return true;
  }

  void _prune(DateTime now) {
    _acceptedAttempts.removeWhere(
      (attempt) => now.difference(attempt) > burstWindow,
    );
  }
}
