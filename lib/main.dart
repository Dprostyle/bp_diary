import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/storage/key_value_store.dart';
import 'core/theme/app_colors.dart';
import 'data/measurement_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  final preferences = await SharedPreferences.getInstance();
  final repository = MeasurementRepository(PreferencesStore(preferences));
  await repository.load();
  runApp(BpDiaryApp(repository: repository));
}
