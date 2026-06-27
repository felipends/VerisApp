enum ActivityType {
  feeding,
  sleepStarted,
  sleepEnded,
  diaper;

  String get label => switch (this) {
    ActivityType.feeding => 'Mamou',
    ActivityType.sleepStarted => 'Dormiu',
    ActivityType.sleepEnded => 'Acordou',
    ActivityType.diaper => 'Fralda',
  };

  static ActivityType fromName(String name) => ActivityType.values.byName(name);
}
