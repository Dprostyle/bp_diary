import 'package:flutter/material.dart';

import 'app_dimens.dart';

extension AppScale on BuildContext {
  double get uiScale => uiScaleFor(MediaQuery.sizeOf(this).width);

  double px(double token) => token * uiScale;
}
