import '../domain/baby_activity.dart';
import '../domain/activity_type.dart';
import 'local_activity_storage.dart';

class ActivityRepository {
  ActivityRepository(this._storage);

  final LocalActivityStorage _storage;

  Future<List<BabyActivity>> load() async =>
      _sort(await _storage.loadActivities());

  Future<BabyActivity> add(
    ActivityType type, {
    DateTime? now,
    String? note,
  }) async {
    final activities = await load();
    final activity = BabyActivity.create(type, now: now, note: note);
    await _storage.saveActivities(_sort([activity, ...activities]));
    return activity;
  }

  Future<BabyActivity> update(BabyActivity activity) async {
    final activities = await load();
    final updated = activities
        .map((existing) => existing.id == activity.id ? activity : existing)
        .toList();
    await _storage.saveActivities(_sort(updated));
    return activity;
  }

  Future<void> delete(String id) async {
    final activities = await load();
    await _storage.saveActivities(
      _sort(activities.where((activity) => activity.id != id).toList()),
    );
  }

  List<BabyActivity> _sort(List<BabyActivity> activities) =>
      [...activities]..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
}
