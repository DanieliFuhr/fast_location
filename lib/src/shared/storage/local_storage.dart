
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static const String historyBoxName = 'search_history';

  static Future<void> initialize() async {
    await Hive.initFlutter();

    if (!Hive.isBoxOpen(historyBoxName)) {
      await Hive.openBox<Map>(historyBoxName);
    }
  }

  static Box<Map> get historyBox {
    return Hive.box<Map>(historyBoxName);
  }

  static Future<void> saveHistory(Map<String, dynamic> item) async {
    await historyBox.add(item);
  }

  static List<Map<String, dynamic>> getHistory() {
    return historyBox.values
        .map((item) => Map<String, dynamic>.from(item))
        .toList()
        .reversed
        .toList();
  }

  static Future<void> clearHistory() async {
    await historyBox.clear();
  }
}
