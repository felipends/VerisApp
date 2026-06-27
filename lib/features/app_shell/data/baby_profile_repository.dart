import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/baby_profile.dart';

class BabyProfileRepository {
  static const _storageKey = 'baby_profile';

  Future<BabyProfile?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return null;
    return BabyProfile.fromJson(
      Map<String, Object?>.from(jsonDecode(raw) as Map),
    );
  }

  Future<void> save(BabyProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(profile.toJson()));
  }
}
