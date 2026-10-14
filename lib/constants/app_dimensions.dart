import 'package:flutter/material.dart';

abstract final class AppDimensions {
  // フォントサイズ
  static const double expressionLarge = 24.0;
  static const double expressionMedium = 18.0;
  static const double expressionSmall = 14.0;

  // 式の文字数によるフォントサイズ切り替え閾値
  static const int expressionLengthMediumThreshold = 15;
  static const int expressionLengthSmallThreshold = 24;

  // キーパッドの高さ比率とクランプ範囲
  static const double keypadHeightRatio = 0.65;
  static const double keypadMinHeight = 360.0;
  static const double keypadMaxHeight = 490.0;

  // 余白・パディング
  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(20, 12, 20, 16);
  static const EdgeInsets keypadPadding = EdgeInsets.fromLTRB(6, 10, 6, 14);
  static const EdgeInsets historyTimelinePadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 4,
  );
  static const EdgeInsets conversionBadgePadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 4,
  );

  // 角丸 (BorderRadius)
  static const double radiusSmall = 4.0;
  static const double radiusKey = 6.0;
  static const double radiusCard = 12.0;
  static const double radiusBadge = 16.0;
  static const double radiusKeypadTop = 24.0;

  // アニメーション持続時間
  static const Duration animScroll = Duration(milliseconds: 160);
  static const Duration toastDuration = Duration(seconds: 2);
}
