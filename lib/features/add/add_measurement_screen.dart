import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_scale.dart';
import '../../data/measurement.dart';
import '../../data/pressure_level.dart';
import '../../data/reading_format.dart';
import '../../widgets/app_content.dart';
import '../../widgets/measurement_scope.dart';
import '../../widgets/primary_button.dart';

class AddMeasurementScreen extends StatefulWidget {
  const AddMeasurementScreen({this.existing, super.key});

  final Measurement? existing;

  @override
  State<AddMeasurementScreen> createState() => _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends State<AddMeasurementScreen> {
  late final List<String> _values;
  var _active = 0;
  var _saving = false;
  final _recordedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _values = existing == null
        ? ['', '', '']
        : [
            existing.systolic.toString(),
            existing.diastolic.toString(),
            existing.pulse.toString(),
          ];
  }

  int? _parse(int index) {
    final raw = _values[index];
    if (raw.isEmpty) return null;
    return int.tryParse(raw);
  }

  String? get _error {
    return PressureRules.validate(
      systolic: _parse(0),
      diastolic: _parse(1),
      pulse: _parse(2),
    );
  }

  bool get _canSave =>
      !_saving &&
      _parse(0) != null &&
      _parse(1) != null &&
      _parse(2) != null &&
      _error == null;

  void _type(String digit) {
    final current = _values[_active];
    if (current.length >= 3) return;
    final next = current + digit;
    if (next.startsWith('0')) return;
    setState(() => _values[_active] = next);
    if (next.length == 3 && _active < 2) {
      setState(() => _active += 1);
    }
  }

  void _backspace() {
    final current = _values[_active];
    if (current.isEmpty) return;
    setState(() => _values[_active] = current.substring(0, current.length - 1));
  }

  Future<void> _save() async {
    if (!_canSave) return;
    setState(() => _saving = true);
    final repo = MeasurementScope.of(context);
    final systolic = _parse(0)!;
    final diastolic = _parse(1)!;
    final pulse = _parse(2)!;
    final existing = widget.existing;
    if (existing == null) {
      await repo.add(
        systolic: systolic,
        diastolic: diastolic,
        pulse: pulse,
        recordedAt: _recordedAt,
      );
    } else {
      await repo.update(
        id: existing.id,
        systolic: systolic,
        diastolic: diastolic,
        pulse: pulse,
      );
    }
    if (!mounted) return;
    Navigator.of(context).pop();
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final when = widget.existing?.recordedAt ?? _recordedAt;
    final error = _values.every((value) => value.length >= 2) ? _error : null;
    return Scaffold(
      body: SafeArea(
        child: AppContent(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.px(AppDimens.lg),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: context.px(AppDimens.buttonHeight),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    iconSize: context.px(AppDimens.iconLg),
                                    icon: const Icon(Icons.arrow_back_rounded),
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.existing == null
                                          ? AppStrings.newMeasurement
                                          : AppStrings.editMeasurement,
                                      textAlign: TextAlign.center,
                                      style: text.headlineSmall,
                                    ),
                                  ),
                                  SizedBox(width: context.px(AppDimens.minTouch)),
                                ],
                              ),
                            ),
                            Text(formatFullWhen(when), style: text.bodyLarge),
                            SizedBox(height: context.px(AppDimens.md)),
                            _ValueField(
                              label: AppStrings.upper,
                              unit: AppStrings.unitPressure,
                              value: _values[0],
                              selected: _active == 0,
                              onTap: () => setState(() => _active = 0),
                            ),
                            SizedBox(height: context.px(AppDimens.sm)),
                            _ValueField(
                              label: AppStrings.lower,
                              unit: AppStrings.unitPressure,
                              value: _values[1],
                              selected: _active == 1,
                              onTap: () => setState(() => _active = 1),
                            ),
                            SizedBox(height: context.px(AppDimens.sm)),
                            _ValueField(
                              label: AppStrings.pulse,
                              unit: AppStrings.unitPulse,
                              value: _values[2],
                              selected: _active == 2,
                              onTap: () => setState(() => _active = 2),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: context.px(AppDimens.md)),
                            if (error != null)
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: context.px(AppDimens.sm),
                                ),
                                child: Text(
                                  error,
                                  textAlign: TextAlign.center,
                                  style: text.titleMedium?.copyWith(
                                    color: AppColors.danger,
                                  ),
                                ),
                              ),
                            _Keypad(
                              onDigit: _type,
                              onBackspace: _backspace,
                              onClear: () => setState(() => _values[_active] = ''),
                            ),
                            SizedBox(height: context.px(AppDimens.sm)),
                            PrimaryButton(
                              key: const ValueKey('save-measurement'),
                              label: AppStrings.save,
                              onPressed: _canSave ? _save : null,
                            ),
                            SizedBox(height: context.px(AppDimens.md)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ValueField extends StatelessWidget {
  const _ValueField({
    required this.label,
    required this.unit,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String unit;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(context.px(AppDimens.radiusMd)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.px(AppDimens.radiusMd)),
        child: Container(
          height: context.px(AppDimens.fieldHeight),
          padding: EdgeInsets.symmetric(horizontal: context.px(AppDimens.md)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.px(AppDimens.radiusMd)),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider,
              width: context.px(AppDimens.borderWidth),
            ),
          ),
          child: Row(
            children: [
              Expanded(child: Text(label, style: text.titleMedium)),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value.isEmpty ? AppStrings.dash : value,
                    style: text.displayMedium?.copyWith(
                      color: value.isEmpty
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: context.px(AppDimens.sm)),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(unit, style: text.bodySmall),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.onDigit,
    required this.onBackspace,
    required this.onClear,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['C', '0', '⌫'],
    ];
    return Column(
      children: [
        for (final row in rows) ...[
          Row(
            children: [
              for (final key in row)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(context.px(AppDimens.xs)),
                    child: _Key(
                      label: key,
                      onTap: () {
                        if (key == 'C') {
                          onClear();
                        } else if (key == '⌫') {
                          onBackspace();
                        } else {
                          onDigit(key);
                        }
                      },
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final semantics = switch (label) {
      'C' => AppStrings.clearDigit,
      '⌫' => AppStrings.deleteDigit,
      _ => label,
    };
    return Semantics(
      key: ValueKey('pad-$label'),
      button: true,
      label: semantics,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.px(AppDimens.radiusSm)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(context.px(AppDimens.radiusSm)),
          child: SizedBox(
            height: context.px(AppDimens.keyHeight),
            child: Center(
              child: Text(label, style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
        ),
      ),
    );
  }
}
