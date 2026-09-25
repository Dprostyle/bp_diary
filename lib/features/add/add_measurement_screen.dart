import 'package:bp_diary/core/format/ru_date.dart';
import 'package:bp_diary/core/theme/app_colors.dart';
import 'package:bp_diary/core/theme/app_dimens.dart';
import 'package:bp_diary/core/theme/app_theme.dart';
import 'package:bp_diary/core/theme/app_typography.dart';
import 'package:bp_diary/data/measurement.dart';
import 'package:bp_diary/widgets/measurement_scope.dart';
import 'package:bp_diary/widgets/primary_button.dart';
import 'package:bp_diary/widgets/screen_title.dart';
import 'package:flutter/cupertino.dart';

class AddMeasurementScreen extends StatefulWidget {
  const AddMeasurementScreen({super.key});

  static const saveKey = Key('save-measurement');

  @override
  State<AddMeasurementScreen> createState() => _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends State<AddMeasurementScreen> {
  late final DateTime _openedAt;
  late final FixedExtentScrollController _systolicController;
  late final FixedExtentScrollController _diastolicController;
  late final FixedExtentScrollController _pulseController;

  int _systolic = MeasurementBounds.defaultSystolic;
  int _diastolic = MeasurementBounds.defaultDiastolic;
  int _pulse = MeasurementBounds.defaultPulse;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _openedAt = DateTime.now();
    _systolicController = FixedExtentScrollController(
      initialItem: _systolic - MeasurementBounds.systolicMin,
    );
    _diastolicController = FixedExtentScrollController(
      initialItem: _diastolic - MeasurementBounds.diastolicMin,
    );
    _pulseController = FixedExtentScrollController(
      initialItem: _pulse - MeasurementBounds.pulseMin,
    );
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }
    final navigator = Navigator.of(context);
    if (_systolic <= _diastolic) {
      await _showMessage(
        title: 'Проверьте значения',
        message: 'Верхнее давление должно быть больше нижнего.',
      );
      return;
    }
    setState(() => _saving = true);
    final controller = MeasurementScope.of(context);
    try {
      await controller.add(
        systolic: _systolic,
        diastolic: _diastolic,
        pulse: _pulse,
        recordedAt: DateTime.now(),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _saving = false);
      await _showMessage(
        title: 'Не сохранилось',
        message: 'Попробуйте ещё раз.',
      );
      return;
    }
    if (!mounted) {
      return;
    }
    navigator.pop(true);
  }

  Future<void> _showMessage({required String title, required String message}) {
    return showCupertinoDialog<void>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Хорошо'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = context.appText;
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceLg,
                  vertical: AppDimens.spaceMd,
                ),
                foregroundColor: AppColors.accent,
                pressedOpacity: AppDimens.pressedOpacity,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Закрыть',
                  style: text.titleMedium?.copyWith(color: AppColors.accent),
                ),
              ),
            ),
            const ScreenTitle('Новое измерение', top: AppDimens.spaceXs),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.spaceLg,
                  AppDimens.spaceSm,
                  AppDimens.spaceLg,
                  AppDimens.spaceMd,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Время записи', style: text.bodyMedium),
                    const SizedBox(height: AppDimens.spaceXs),
                    Text(RuDate.dateTime(_openedAt), style: text.titleLarge),
                    const SizedBox(height: AppDimens.spaceXl),
                    DecoratedBox(
                      decoration: AppDecorations.flat,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceSm,
                          vertical: AppDimens.spaceMd,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _ValuePicker(
                                label: 'Верхнее',
                                unit: 'мм рт. ст.',
                                min: MeasurementBounds.systolicMin,
                                max: MeasurementBounds.systolicMax,
                                controller: _systolicController,
                                onChanged: (value) => _systolic = value,
                              ),
                            ),
                            Expanded(
                              child: _ValuePicker(
                                label: 'Нижнее',
                                unit: 'мм рт. ст.',
                                min: MeasurementBounds.diastolicMin,
                                max: MeasurementBounds.diastolicMax,
                                controller: _diastolicController,
                                onChanged: (value) => _diastolic = value,
                              ),
                            ),
                            Expanded(
                              child: _ValuePicker(
                                label: 'Пульс',
                                unit: 'уд/мин',
                                min: MeasurementBounds.pulseMin,
                                max: MeasurementBounds.pulseMax,
                                controller: _pulseController,
                                onChanged: (value) => _pulse = value,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.spaceLg,
                AppDimens.spaceSm,
                AppDimens.spaceLg,
                AppDimens.spaceLg,
              ),
              child: PrimaryButton(
                key: AddMeasurementScreen.saveKey,
                label: 'Сохранить',
                onPressed: _saving ? null : _save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValuePicker extends StatelessWidget {
  const _ValuePicker({
    required this.label,
    required this.unit,
    required this.min,
    required this.max,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final String unit;
  final int min;
  final int max;
  final FixedExtentScrollController controller;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final text = context.appText;
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(label, maxLines: 1, style: text.titleMedium),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(unit, maxLines: 1, style: text.bodySmall),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        SizedBox(
          height: AppDimens.pickerHeight,
          child: CupertinoPicker(
            scrollController: controller,
            itemExtent: AppDimens.pickerItemExtent,
            diameterRatio: AppDimens.pickerDiameterRatio,
            onSelectedItemChanged: (index) => onChanged(min + index),
            selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
              background: AppColors.accentSoft,
            ),
            children: [
              for (var value = min; value <= max; value++)
                Center(child: Text('$value', style: text.headlineMedium)),
            ],
          ),
        ),
      ],
    );
  }
}
