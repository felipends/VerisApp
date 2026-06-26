import '../domain/baby_activity.dart';
import '../domain/activity_type.dart';
import 'local_activity_storage.dart';

class ActivityRepository {
  ActivityRepository(this._storage);

  final LocalActivityStorage _storage;

  Future<List<BabyActivity>> load() async =>
      _sort(await _storage.loadActivities());

  Future<BabyActivity> add(ActivityType type) async {
    final activities = await load();
    final activity = BabyActivity.create(type);
    await _storage.saveActivities(_sort([activity, ...activities]));
    return activity;
  }

  List<BabyActivity> _sort(List<BabyActivity> activities) =>
      [...activities]..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
}
