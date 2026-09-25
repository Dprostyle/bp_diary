import 'package:bp_diary/core/theme/app_dimens.dart';
import 'package:flutter/widgets.dart';

abstract final class AppScale {
  static double of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width / AppDimens.baselineWidth)
        .clamp(AppDimens.scaleMin, AppDimens.scaleMax)
        .toDouble();
  }
}
