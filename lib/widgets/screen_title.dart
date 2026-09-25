import 'package:bp_diary/core/theme/app_dimens.dart';
import 'package:bp_diary/core/theme/app_typography.dart';
import 'package:flutter/widgets.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle(this.text, {this.top = AppDimens.spaceMd, super.key});

  final String text;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimens.spaceLg,
        top,
        AppDimens.spaceLg,
        AppDimens.spaceSm,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Semantics(
          header: true,
          child: Text(text, style: context.appText.headlineLarge, maxLines: 2),
        ),
      ),
    );
  }
}
