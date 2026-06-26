import 'package:flutter/material.dart';

import '../domain/activity_type.dart';

extension ActivityTypeIcon on ActivityType {
  IconData get icon => switch (this) {
    ActivityType.feeding => Icons.water_drop_outlined,
    ActivityType.sleepStarted => Icons.nightlight_round,
    ActivityType.sleepEnded => Icons.wb_sunny_outlined,
  };
}
