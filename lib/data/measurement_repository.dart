import 'dart:convert';

import 'package:bp_diary/data/measurement.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MeasurementRepository {
  Future<List<Measurement>> load();

  Future<void> save(List<Measurement> items);
}

class MemoryMeasurementRepository implements MeasurementRepository {
  final List<Measurement> _items = [];

  @override
  Future<List<Measurement>> load() async => List.unmodifiable(_items);

  @override
  Future<void> save(List<Measurement> items) async {
    _items
      ..clear()
      ..addAll(items);
  }
}

class SharedPrefsMeasurementRepository implements MeasurementRepository {
  static const storageKey = 'bp_measurements_v1';

  @override
  Future<List<Measurement>> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(storageKey);
      if (raw == null || raw.isEmpty) {
        return const [];
      }
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const [];
      }
      final items = <Measurement>[];
      for (final entry in decoded) {
        if (entry is Map<String, dynamic>) {
          items.add(Measurement.fromJson(entry));
        } else if (entry is Map) {
          items.add(Measurement.fromJson(Map<String, dynamic>.from(entry)));
        }
      }
      items.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
      return List.unmodifiable(items);
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> save(List<Measurement> items) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(items.map((item) => item.toJson()).toList());
    await prefs.setString(storageKey, raw);
  }
}
