import 'package:bp_diary/app.dart';
import 'package:bp_diary/data/measurement_controller.dart';
import 'package:bp_diary/data/measurement_repository.dart';
import 'package:bp_diary/features/add/add_measurement_screen.dart';
import 'package:bp_diary/features/shell/app_bottom_bar.dart';
import 'package:bp_diary/widgets/measurement_scope.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  final controller = MeasurementController(MemoryMeasurementRepository());
  await controller.load();
  await tester.pumpWidget(
    MeasurementScope(controller: controller, child: const BpApp()),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('main screen shows history, add, and settings', (tester) async {
    await _pumpApp(tester);

    expect(find.text('История'), findsNWidgets(2));
    expect(find.text('Настройки'), findsOneWidget);
    expect(find.text('Пока нет измерений'), findsOneWidget);
    expect(find.byKey(AppBottomBar.addKey), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings explains local storage', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byKey(AppBottomBar.settingsKey));
    await tester.pumpAndSettle();

    expect(find.text('Настройки'), findsNWidgets(2));
    expect(
      find.text('Записи хранятся только на этом устройстве.'),
      findsOneWidget,
    );
    expect(find.text('Пока нет измерений'), findsNothing);
  });

  testWidgets('saving a reading shows it in history', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byKey(AppBottomBar.addKey));
    await tester.pumpAndSettle();

    expect(find.text('Новое измерение'), findsOneWidget);
    expect(find.text('Время записи'), findsOneWidget);

    await tester.tap(find.byKey(AddMeasurementScreen.saveKey));
    await tester.pumpAndSettle();

    expect(find.text('Пока нет измерений'), findsNothing);
    expect(find.text('120'), findsOneWidget);
    expect(find.text('80'), findsOneWidget);
    expect(find.textContaining('70 уд/мин'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('small phone and large text do not overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await _pumpApp(tester);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(AppBottomBar.addKey));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(AddMeasurementScreen.saveKey));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(1024, 1366);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
