import 'package:flutter/material.dart';

import 'core/theme/app_dimens.dart';
import 'core/theme/app_theme.dart';
import 'data/measurement_repository.dart';
import 'features/home/empty_home_screen.dart';
import 'features/shell/main_shell.dart';
import 'widgets/measurement_scope.dart';

class BpDiaryApp extends StatelessWidget {
  const BpDiaryApp({required this.repository, super.key});

  final MeasurementRepository repository;

  @override
  Widget build(BuildContext context) {
    return MeasurementScope(
      repository: repository,
      child: MaterialApp(
        title: 'Мой Давление',
        debugShowCheckedModeBanner: false,
        scrollBehavior: const AppScrollBehavior(),
        theme: AppTheme.light(1),
        builder: (context, child) {
          final media = MediaQuery.of(context);
          final scale = uiScaleFor(media.size.width);
          final scaler = media.textScaler.clamp(
            minScaleFactor: AppDimens.textMinScale,
            maxScaleFactor: AppDimens.textMaxScale,
          );
          return MediaQuery(
            data: media.copyWith(textScaler: scaler),
            child: Theme(
              data: AppTheme.light(scale),
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
        home: ListenableBuilder(
          listenable: repository,
          builder: (context, _) {
            if (!repository.isReady) {
              return const Scaffold(body: SizedBox.expand());
            }
            if (repository.measurements.isEmpty) {
              return const EmptyHomeScreen();
            }
            return const MainShell();
          },
        ),
      ),
    );
  }
}
