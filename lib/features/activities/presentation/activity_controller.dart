import 'package:flutter/foundation.dart';

import '../data/activity_repository.dart';
import '../domain/activity_rate_limiter.dart';
import '../domain/activity_type.dart';
import '../domain/baby_activity.dart';

class ActivityController extends ChangeNotifier {
  ActivityController({
    required this.repository,
    ActivityRateLimiter? rateLimiter,
  }) : rateLimiter = rateLimiter ?? ActivityRateLimiter();

  final ActivityRepository repository;
  final ActivityRateLimiter rateLimiter;
  List<BabyActivity> activities = const [];
  bool isLoading = true;
  bool isSaving = false;
  final Set<ActivityType> _savingTypes = {};
  String? errorMessage;

  bool get isActionDisabled => isSaving;
  bool isTypeSaving(ActivityType type) => _savingTypes.contains(type);

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      activities = await repository.load();
    } catch (_) {
      errorMessage = 'Nao foi possivel carregar as atividades.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<BabyActivity?> add(
    ActivityType type, {
    DateTime? now,
    String? note,
  }) async {
    final timestamp = now ?? DateTime.now();
    if (isSaving ||
        _savingTypes.contains(type) ||
        !rateLimiter.shouldAccept(type, now: timestamp)) {
      return null;
    }
    isSaving = true;
    _savingTypes.add(type);
    notifyListeners();
    try {
      final activity = await repository.add(type, now: timestamp, note: note);
      rateLimiter.recordAccepted(type, now: timestamp);
      activities = _sort([activity, ...activities]);
      errorMessage = null;
      return activity;
    } catch (_) {
      errorMessage = 'Nao foi possivel salvar. Tente novamente.';
      return null;
    } finally {
      _savingTypes.remove(type);
      isSaving = _savingTypes.isNotEmpty;
      notifyListeners();
    }
  }

  Future<BabyActivity?> update(BabyActivity activity, {DateTime? now}) async {
    if (isSaving) return null;
    isSaving = true;
    notifyListeners();
    try {
      final updated = activity.copyWith(updatedAt: now ?? DateTime.now());
      final saved = await repository.update(updated);
      activities = _sort(
        activities.map((item) => item.id == saved.id ? saved : item).toList(),
      );
      errorMessage = null;
      return saved;
    } catch (_) {
      errorMessage = 'Nao foi possivel atualizar. Tente novamente.';
      return null;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> delete(String id) async {
    if (isSaving) return false;
    isSaving = true;
    notifyListeners();
    try {
      await repository.delete(id);
      activities = activities.where((activity) => activity.id != id).toList();
      errorMessage = null;
      return true;
    } catch (_) {
      errorMessage = 'Nao foi possivel excluir. Tente novamente.';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  List<BabyActivity> _sort(List<BabyActivity> items) =>
      [...items]..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
}
