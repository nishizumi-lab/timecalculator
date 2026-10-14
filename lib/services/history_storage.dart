import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation_record.dart';

class HistoryStorage {
  static const _recordsKey = 'records';
  static const int maxRecords = 200;

  SharedPreferences? _prefs;
  List<CalculationRecord> records = [];
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> _ensureLoaded() async {
    if (!_isLoaded) {
      await load();
    }
  }

  Future<void> load() async {
    final prefs = await _getPrefs();
    final raw = prefs.getStringList(_recordsKey) ?? [];
    final loaded = <CalculationRecord>[];
    for (final item in raw) {
      try {
        final decoded = jsonDecode(item);
        if (decoded is Map<String, dynamic>) {
          loaded.add(CalculationRecord.fromJson(decoded));
        }
      } catch (_) {
        // 不正または破損したレコードを安全にスキップ
      }
    }
    loaded.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (loaded.length > maxRecords) {
      records = loaded.sublist(0, maxRecords);
    } else {
      records = loaded;
    }
    _isLoaded = true;
  }

  Future<void> upsert(CalculationRecord record) async {
    await _ensureLoaded();
    records.removeWhere((item) => item.id == record.id);
    records.insert(0, record);
    if (records.length > maxRecords) {
      records = records.sublist(0, maxRecords);
    }
    await _persist();
  }

  Future<void> delete(String id) async {
    await _ensureLoaded();
    records.removeWhere((item) => item.id == id);
    await _persist();
  }

  Future<void> clearAll() async {
    await _ensureLoaded();
    records.clear();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await _getPrefs();
    await prefs.setStringList(
      _recordsKey,
      records.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }
}
