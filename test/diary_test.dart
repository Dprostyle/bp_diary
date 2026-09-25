import 'package:bp_diary/core/format/ru_date.dart';
import 'package:bp_diary/data/measurement.dart';
import 'package:bp_diary/data/measurement_controller.dart';
import 'package:bp_diary/data/measurement_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('formats russian date and time', () {
    final value = DateTime(2026, 9, 26, 7, 5);
    expect(RuDate.date(value), '26 сентября 2026');
    expect(RuDate.time(value), '07:05');
    expect(RuDate.dateTime(value), '26 сентября 2026, 07:05');
  });

  test('measurement json roundtrip', () {
    final item = Measurement(
      id: '1',
      systolic: 128,
      diastolic: 82,
      pulse: 71,
      recordedAt: DateTime.utc(2026, 9, 26, 8, 30),
    );
    final copy = Measurement.fromJson(item.toJson());
    expect(copy.id, item.id);
    expect(copy.systolic, 128);
    expect(copy.diastolic, 82);
    expect(copy.pulse, 71);
    expect(copy.recordedAt.isAtSameMomentAs(item.recordedAt), isTrue);
  });

  test('controller keeps the newest reading first', () async {
    final controller = MeasurementController(MemoryMeasurementRepository());
    await controller.add(
      systolic: 110,
      diastolic: 70,
      pulse: 60,
      recordedAt: DateTime.utc(2026, 9, 25, 9),
    );
    await controller.add(
      systolic: 130,
      diastolic: 85,
      pulse: 77,
      recordedAt: DateTime.utc(2026, 9, 26, 9),
    );
    expect(controller.items.first.systolic, 130);
    expect(controller.items.last.systolic, 110);
  });

  test('prefs repository roundtrip and broken payload', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final repo = SharedPrefsMeasurementRepository();
    final older = Measurement(
      id: 'a',
      systolic: 118,
      diastolic: 76,
      pulse: 64,
      recordedAt: DateTime.utc(2026, 9, 24, 8),
    );
    final newer = Measurement(
      id: 'b',
      systolic: 132,
      diastolic: 86,
      pulse: 74,
      recordedAt: DateTime.utc(2026, 9, 26, 8),
    );
    await repo.save([older, newer]);
    final loaded = await repo.load();
    expect(loaded.first.id, 'b');
    expect(loaded.last.systolic, 118);

    SharedPreferences.setMockInitialValues({
      SharedPrefsMeasurementRepository.storageKey: '{bad',
    });
    expect(await SharedPrefsMeasurementRepository().load(), isEmpty);
  });
}
