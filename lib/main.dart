import 'package:bp_diary/app.dart';
import 'package:bp_diary/core/theme/app_colors.dart';
import 'package:bp_diary/data/measurement_controller.dart';
import 'package:bp_diary/data/measurement_repository.dart';
import 'package:bp_diary/widgets/measurement_scope.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    ),
  );
  final controller = MeasurementController(SharedPrefsMeasurementRepository());
  await controller.load();
  runApp(MeasurementScope(controller: controller, child: const BpApp()));
}
