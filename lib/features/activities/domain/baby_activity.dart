import 'activity_type.dart';

const Object _unset = Object();

class BabyActivity {
  const BabyActivity({
    required this.id,
    required this.type,
    required this.occurredAt,
    required this.createdAt,
    this.updatedAt,
    this.note,
  });

  factory BabyActivity.create(
    ActivityType type, {
    DateTime? now,
    String? note,
  }) {
    final timestamp = now ?? DateTime.now();
    return BabyActivity(
      id: '${timestamp.microsecondsSinceEpoch}-${type.name}',
      type: type,
      occurredAt: timestamp,
      createdAt: timestamp,
      note: note,
    );
  }

  factory BabyActivity.fromJson(Map<String, Object?> json) {
    return BabyActivity(
      id: json['id'] as String,
      type: ActivityType.fromName(json['type'] as String),
      occurredAt: DateTime.parse(json['occurredAt'] as String).toLocal(),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String).toLocal(),
      note: json['note'] as String?,
    );
  }

  final String id;
  final ActivityType type;
  final DateTime occurredAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? note;

  Map<String, Object?> toJson() => {
    'id': id,
    'type': type.name,
    'occurredAt': occurredAt.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    if (note != null) 'note': note,
  };

  BabyActivity copyWith({
    ActivityType? type,
    DateTime? occurredAt,
    Object? updatedAt = _unset,
    Object? note = _unset,
  }) => BabyActivity(
    id: id,
    type: type ?? this.type,
    occurredAt: occurredAt ?? this.occurredAt,
    createdAt: createdAt,
    updatedAt: updatedAt == _unset ? this.updatedAt : updatedAt as DateTime?,
    note: note == _unset ? this.note : note as String?,
  );
}
