import 'package:flutter/material.dart';

import '../data/measurement_repository.dart';

class MeasurementScope extends InheritedNotifier<MeasurementRepository> {
  const MeasurementScope({
    required MeasurementRepository repository,
    required super.child,
    super.key,
  }) : super(notifier: repository);

  static MeasurementRepository of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<MeasurementScope>();
    assert(scope != null, 'MeasurementScope is missing');
    return scope!.notifier!;
  }
}
