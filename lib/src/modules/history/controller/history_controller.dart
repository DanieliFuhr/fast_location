
import 'package:mobx/mobx.dart';

import '../../../shared/storage/local_storage.dart';

class HistoryController {
  final ObservableList<Map<String, dynamic>> _history =
      ObservableList<Map<String, dynamic>>();

  final Observable<bool> _isLoading = Observable(false);

  List<Map<String, dynamic>> get history => _history.toList();

  bool get isLoading => _isLoading.value;

  Future<void> loadHistory() async {
    runInAction(() {
      _isLoading.value = true;
    });

    try {
      final items = LocalStorage.getHistory();

      runInAction(() {
        _history
          ..clear()
          ..addAll(items);
      });
    } finally {
      runInAction(() {
        _isLoading.value = false;
      });
    }
  }

  Future<void> clearHistory() async {
    await LocalStorage.clearHistory();

    runInAction(() {
      _history.clear();
    });
  }
}
