import 'package:flutter/foundation.dart';

import '../data/activity_repository.dart';
import '../domain/activity_type.dart';
import '../domain/baby_activity.dart';

class ActivityController extends ChangeNotifier {
  ActivityController({required this.repository});

  final ActivityRepository repository;
  List<BabyActivity> activities = const [];
  bool isLoading = true;
  String? errorMessage;

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

  Future<BabyActivity?> add(ActivityType type) async {
    try {
      final activity = await repository.add(type);
      activities = [activity, ...activities]
        ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
      errorMessage = null;
      notifyListeners();
      return activity;
    } catch (_) {
      errorMessage = 'Nao foi possivel salvar. Tente novamente.';
      notifyListeners();
      return null;
    }
  }
}
