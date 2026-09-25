import 'package:bp_diary/data/measurement.dart';
import 'package:bp_diary/data/measurement_repository.dart';
import 'package:flutter/foundation.dart';

class MeasurementController extends ChangeNotifier {
  MeasurementController(this._repository);

  final MeasurementRepository _repository;
  List<Measurement> _items = const [];

  List<Measurement> get items => _items;

  Future<void> load() async {
    try {
      final loaded = await _repository.load();
      _items = List.unmodifiable(_sorted(loaded));
    } catch (_) {
      _items = const [];
    }
    notifyListeners();
  }

  Future<void> add({
    required int systolic,
    required int diastolic,
    required int pulse,
    required DateTime recordedAt,
  }) async {
    final measurement = Measurement(
      id: '${recordedAt.microsecondsSinceEpoch}',
      systolic: systolic,
      diastolic: diastolic,
      pulse: pulse,
      recordedAt: recordedAt,
    );
    final next = _sorted([measurement, ..._items]);
    await _repository.save(next);
    _items = List.unmodifiable(next);
    notifyListeners();
  }
}

List<Measurement> _sorted(List<Measurement> items) {
  final copy = List<Measurement>.of(items);
  copy.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  return copy;
}
