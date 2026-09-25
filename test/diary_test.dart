import 'package:bp_diary/core/storage/key_value_store.dart';
import 'package:bp_diary/data/measurement_repository.dart';
import 'package:bp_diary/data/pressure_level.dart';
import 'package:bp_diary/core/theme/app_dimens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ui scale stays inside 0.9–1.1', () {
    expect(uiScaleFor(390), 1);
    expect(uiScaleFor(200), AppDimens.uiMinScale);
    expect(uiScaleFor(1200), AppDimens.uiMaxScale);
  });

  test('120/78 is normal', () {
    expect(PressureRules.levelFor(120, 78), PressureLevel.normal);
    expect(PressureRules.levelFor(135, 80), PressureLevel.elevated);
    expect(PressureRules.levelFor(150, 92), PressureLevel.high);
    expect(PressureRules.levelFor(182, 100), PressureLevel.crisis);
  });

  test('rejects invalid reading', () {
    expect(
      PressureRules.validate(systolic: 120, diastolic: 130, pulse: 70),
      isNotNull,
    );
    expect(
      PressureRules.validate(systolic: 120, diastolic: 80, pulse: 72),
      isNull,
    );
  });

  test('repository keeps readings on device storage', () async {
    final store = _MemoryStore();
    final repo = MeasurementRepository(store);
    await repo.load();
    await repo.add(systolic: 120, diastolic: 78, pulse: 72);
    final again = MeasurementRepository(store);
    await again.load();
    expect(again.measurements, hasLength(1));
    expect(again.latest!.systolic, 120);
    await again.clear();
    expect(again.measurements, isEmpty);
  });
}

class _MemoryStore implements KeyValueStore {
  final _data = <String, String>{};

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> remove(String key) async => _data.remove(key);

  @override
  Future<void> write(String key, String value) async => _data[key] = value;
}
