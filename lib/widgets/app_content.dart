import 'package:flutter/material.dart';

import '../core/theme/app_dimens.dart';
import '../core/theme/app_scale.dart';

class AppContent extends StatelessWidget {
  const AppContent({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: context.px(AppDimens.contentMaxWidth),
        ),
        child: child,
      ),
    );
  }
}
