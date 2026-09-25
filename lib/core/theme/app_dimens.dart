abstract final class AppDimens {
  static const double designWidth = 390;

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
  static const double xxxl = 48;

  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 24;
  static const double radiusXl = 28;
  static const double radiusPill = 999;

  static const double iconSm = 18;
  static const double iconMd = 24;
  static const double iconLg = 28;
  static const double iconXl = 36;

  static const double buttonHeight = 58;
  static const double fieldHeight = 72;
  static const double navHeight = 64;
  static const double fabSize = 64;
  static const double minTouch = 48;
  static const double keyHeight = 56;
  static const double logoSize = 42;
  static const double featureIcon = 56;
  static const double heartArt = 108;
  static const double chartHeight = 220;
  static const double illustrationHeight = 240;
  static const double contentMaxWidth = 480;
  static const double borderWidth = 2;
  static const double chartStroke = 3;
  static const double chartDot = 5;

  static const double textMinScale = 0.9;
  static const double textMaxScale = 1.2;
  static const double uiMinScale = 0.9;
  static const double uiMaxScale = 1.1;
}

double uiScaleFor(double width) {
  return (width / AppDimens.designWidth).clamp(
    AppDimens.uiMinScale,
    AppDimens.uiMaxScale,
  );
}
