enum ActivityType {
  feeding,
  sleepStarted,
  sleepEnded;

  String get label => switch (this) {
    ActivityType.feeding => 'Mamou',
    ActivityType.sleepStarted => 'Dormiu',
    ActivityType.sleepEnded => 'Acordou',
  };

  static ActivityType fromName(String name) => ActivityType.values.byName(name);
}
