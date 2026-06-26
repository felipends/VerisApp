import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/baby_activity.dart';

class LocalActivityStorage {
  static const _storageKey = 'baby_activities';

  Future<List<BabyActivity>> loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final rawActivities = prefs.getStringList(_storageKey) ?? const <String>[];
    return rawActivities
        .map(
          (raw) =>
              BabyActivity.fromJson(jsonDecode(raw) as Map<String, Object?>),
        )
        .toList();
  }

  Future<void> saveActivities(List<BabyActivity> activities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      activities.map((activity) => jsonEncode(activity.toJson())).toList(),
    );
  }
}
