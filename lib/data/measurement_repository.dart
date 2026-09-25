import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../core/storage/key_value_store.dart';
import 'measurement.dart';
import 'pressure_level.dart';

class MeasurementRepository extends ChangeNotifier {
  MeasurementRepository(this._store);

  static const storageKey = 'measurements_v1';

  final KeyValueStore _store;
  final List<Measurement> _items = [];
  var _ready = false;
  var _seq = 0;

  bool get isReady => _ready;

  List<Measurement> get measurements => List.unmodifiable(_items);

  Measurement? findById(String id) {
    for (final item in _items) {
      if (item.id == id) return item;
    }
    return null;
  }

  Measurement? get latest => _items.isEmpty ? null : _items.first;

  Future<void> load() async {
    final raw = await _store.read(storageKey);
    _items.clear();
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        final list = decoded is Map<String, dynamic>
            ? decoded['items'] as List<dynamic>
            : decoded as List<dynamic>;
        _items.addAll(
          list.map((item) => Measurement.fromJson(item as Map<String, dynamic>)),
        );
        _items.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
      } catch (_) {
        _items.clear();
      }
    }
    _ready = true;
    notifyListeners();
  }

  Future<Measurement> add({
    required int systolic,
    required int diastolic,
    required int pulse,
    DateTime? recordedAt,
  }) async {
    _ensureValid(systolic, diastolic, pulse);
    final item = Measurement(
      id: '${DateTime.now().microsecondsSinceEpoch}-${_seq++}',
      recordedAt: recordedAt ?? DateTime.now(),
      systolic: systolic,
      diastolic: diastolic,
      pulse: pulse,
    );
    _items.add(item);
    _items.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    await _persist();
    notifyListeners();
    return item;
  }

  Future<void> update({
    required String id,
    required int systolic,
    required int diastolic,
    required int pulse,
  }) async {
    _ensureValid(systolic, diastolic, pulse);
    final index = _items.indexWhere((item) => item.id == id);
    if (index < 0) return;
    _items[index] = _items[index].copyWith(
      systolic: systolic,
      diastolic: diastolic,
      pulse: pulse,
    );
    await _persist();
    notifyListeners();
  }

  Future<void> delete(String id) async {
    _items.removeWhere((item) => item.id == id);
    await _persist();
    notifyListeners();
  }

  Future<void> clear() async {
    _items.clear();
    await _store.remove(storageKey);
    notifyListeners();
  }

  List<DayReading> dailySeries(int days, [DateTime? now]) {
    final clock = (now ?? DateTime.now()).toLocal();
    final start = DateTime(clock.year, clock.month, clock.day)
        .subtract(Duration(days: days - 1));
    final lastByDay = <DateTime, Measurement>{};
    for (final item in _items) {
      final local = item.recordedAt.toLocal();
      final day = DateTime(local.year, local.month, local.day);
      if (day.isBefore(start)) continue;
      final existing = lastByDay[day];
      if (existing == null || item.recordedAt.isAfter(existing.recordedAt)) {
        lastByDay[day] = item;
      }
    }
    final keys = lastByDay.keys.toList()..sort();
    return [
      for (final day in keys)
        DayReading(
          day: day,
          systolic: lastByDay[day]!.systolic,
          diastolic: lastByDay[day]!.diastolic,
        ),
    ];
  }

  void _ensureValid(int systolic, int diastolic, int pulse) {
    final error = PressureRules.validate(
      systolic: systolic,
      diastolic: diastolic,
      pulse: pulse,
    );
    if (error != null) {
      throw ArgumentError(error);
    }
  }

  Future<void> _persist() async {
    final raw = jsonEncode({
      'v': 1,
      'items': _items.map((item) => item.toJson()).toList(),
    });
    await _store.write(storageKey, raw);
  }
}
