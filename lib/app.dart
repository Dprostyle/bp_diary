import 'package:bp_diary/core/theme/app_colors.dart';
import 'package:bp_diary/core/theme/app_dimens.dart';
import 'package:bp_diary/core/theme/app_scale.dart';
import 'package:bp_diary/core/theme/app_theme.dart';
import 'package:bp_diary/features/shell/main_shell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BpApp extends StatelessWidget {
  const BpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Давление',
      debugShowCheckedModeBanner: false,
      color: AppColors.accent,
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.accent,
        scaffoldBackgroundColor: AppColors.background,
      ),
      builder: (context, child) {
        final scale = AppScale.of(context);
        final scaler = MediaQuery.textScalerOf(context).clamp(
          minScaleFactor: AppDimens.textScaleMin,
          maxScaleFactor: AppDimens.textScaleMax,
        );
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: scaler),
          child: Theme(
            data: AppTheme.material(scale),
            child: CupertinoTheme(
              data: AppTheme.cupertino(scale),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
      home: const MainShell(),
    );
  }
}
