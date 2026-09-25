import 'package:bp_diary/data/measurement_controller.dart';
import 'package:flutter/widgets.dart';

class MeasurementScope extends InheritedNotifier<MeasurementController> {
  const MeasurementScope({
    required MeasurementController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static MeasurementController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<MeasurementScope>();
    assert(scope != null, 'MeasurementScope not found');
    return scope!.notifier!;
  }
}
