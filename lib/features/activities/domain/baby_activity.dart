import 'activity_type.dart';

class BabyActivity {
  const BabyActivity({
    required this.id,
    required this.type,
    required this.occurredAt,
    required this.createdAt,
  });

  factory BabyActivity.create(ActivityType type, {DateTime? now}) {
    final timestamp = now ?? DateTime.now();
    return BabyActivity(
      id: '${timestamp.microsecondsSinceEpoch}-${type.name}',
      type: type,
      occurredAt: timestamp,
      createdAt: timestamp,
    );
  }

  factory BabyActivity.fromJson(Map<String, Object?> json) {
    return BabyActivity(
      id: json['id'] as String,
      type: ActivityType.fromName(json['type'] as String),
      occurredAt: DateTime.parse(json['occurredAt'] as String).toLocal(),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );
  }

  final String id;
  final ActivityType type;
  final DateTime occurredAt;
  final DateTime createdAt;

  Map<String, Object?> toJson() => {
    'id': id,
    'type': type.name,
    'occurredAt': occurredAt.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };
}
