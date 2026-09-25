import 'package:bp_diary/app.dart';
import 'package:bp_diary/core/l10n/app_strings.dart';
import 'package:bp_diary/core/storage/key_value_store.dart';
import 'package:bp_diary/data/measurement_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('empty screen leads to a saved reading', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repo = MeasurementRepository(_MemoryStore());
    await repo.load();
    await tester.pumpWidget(BpDiaryApp(repository: repo));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.emptyTitle), findsOneWidget);
    await tester.ensureVisible(find.text(AppStrings.addMeasurement));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.addMeasurement));
    await tester.pumpAndSettle();

    await _type(tester, '120');
    await tester.ensureVisible(find.text(AppStrings.lower));
    await tester.tap(find.text(AppStrings.lower));
    await tester.pumpAndSettle();
    await _type(tester, '78');
    await tester.ensureVisible(find.text(AppStrings.pulse));
    await tester.tap(find.text(AppStrings.pulse));
    await tester.pumpAndSettle();
    await _type(tester, '72');
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('save-measurement')));
    await tester.tap(find.byKey(const ValueKey('save-measurement')));
    await tester.pumpAndSettle();

    expect(find.text('120 / 78'), findsWidgets);
    expect(find.text(AppStrings.levelNormal), findsWidgets);
    expect(find.text(AppStrings.history), findsOneWidget);
  });

  testWidgets('small screen and large text scale do not overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    final repo = MeasurementRepository(_MemoryStore());
    await repo.load();
    await tester.pumpWidget(BpDiaryApp(repository: repo));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.text(AppStrings.addMeasurement));
    await tester.tap(find.text(AppStrings.addMeasurement));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

Future<void> _type(WidgetTester tester, String digits) async {
  for (final digit in digits.split('')) {
    final key = find.byKey(ValueKey('pad-$digit'));
    await tester.ensureVisible(key);
    await tester.tap(key);
    await tester.pump();
  }
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
