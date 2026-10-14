import 'package:flutter/material.dart';

enum AppThemeType {
  classicDark('classic_dark'),
  midnight('midnight'),
  cyberPurple('cyber_purple'),
  forestEmerald('forest_emerald'),
  sunsetAmber('sunset_amber'),
  roseElegance('rose_elegance'),
  monochrome('monochrome'),
  pureLight('pure_light'),
  sakuraBloom('sakura_bloom'),
  mintFresh('mint_fresh'),
  citrusSunny('citrus_sunny'),
  skyLavender('sky_lavender'),
  cafeLatte('cafe_latte');

  const AppThemeType(this.id);
  final String id;

  bool get isLight =>
      this == pureLight ||
      this == sakuraBloom ||
      this == mintFresh ||
      this == citrusSunny ||
      this == skyLavender ||
      this == cafeLatte;

  static AppThemeType fromId(String? id) {
    if (id == null || id.isEmpty) return AppThemeType.classicDark;
    return AppThemeType.values.firstWhere(
      (e) => e.id == id,
      orElse: () => AppThemeType.classicDark,
    );
  }

  String getLocalizedName(String languageCode) {
    switch (languageCode) {
      case 'ja':
        switch (this) {
          case AppThemeType.classicDark:
            return 'クラシックダーク';
          case AppThemeType.midnight:
            return 'ミッドナイトブルー';
          case AppThemeType.cyberPurple:
            return 'サイバーパープル';
          case AppThemeType.forestEmerald:
            return 'フォレストエメラルド';
          case AppThemeType.sunsetAmber:
            return 'サンセットアンバー';
          case AppThemeType.roseElegance:
            return 'ローズエレガンス';
          case AppThemeType.monochrome:
            return 'モノクローム';
          case AppThemeType.pureLight:
            return 'ピュアライト';
          case AppThemeType.sakuraBloom:
            return 'サクラブルーム';
          case AppThemeType.mintFresh:
            return 'ミントフレッシュ';
          case AppThemeType.citrusSunny:
            return 'シトラスサニー';
          case AppThemeType.skyLavender:
            return 'スカイラベンダー';
          case AppThemeType.cafeLatte:
            return 'カフェラテ';
        }
      case 'zh':
      case 'zh_Hant':
        switch (this) {
          case AppThemeType.classicDark:
            return '经典暗黑';
          case AppThemeType.midnight:
            return '午夜深蓝';
          case AppThemeType.cyberPurple:
            return '赛博紫';
          case AppThemeType.forestEmerald:
            return '森林翡翠';
          case AppThemeType.sunsetAmber:
            return '落日琥珀';
          case AppThemeType.roseElegance:
            return '典雅玫瑰';
          case AppThemeType.monochrome:
            return '黑白极简';
          case AppThemeType.pureLight:
            return '纯净浅白';
          case AppThemeType.sakuraBloom:
            return '樱花粉';
          case AppThemeType.mintFresh:
            return '清新薄荷';
          case AppThemeType.citrusSunny:
            return '阳光柑橘';
          case AppThemeType.skyLavender:
            return '薰衣草天空';
          case AppThemeType.cafeLatte:
            return '拿铁咖啡';
        }
      case 'ko':
        switch (this) {
          case AppThemeType.classicDark:
            return '클래식 다크';
          case AppThemeType.midnight:
            return '미드나이트 블루';
          case AppThemeType.cyberPurple:
            return '사이버 퍼플';
          case AppThemeType.forestEmerald:
            return '포레스트 에메랄드';
          case AppThemeType.sunsetAmber:
            return '선셋 앰버';
          case AppThemeType.roseElegance:
            return '로즈 엘레강스';
          case AppThemeType.monochrome:
            return '모노크롬';
          case AppThemeType.pureLight:
            return '퓨어 라이트';
          case AppThemeType.sakuraBloom:
            return '사쿠라 블룸';
          case AppThemeType.mintFresh:
            return '민트 프레시';
          case AppThemeType.citrusSunny:
            return '시트러스 써니';
          case AppThemeType.skyLavender:
            return '스카이 라벤더';
          case AppThemeType.cafeLatte:
            return '카페 라떼';
        }
      case 'es':
        switch (this) {
          case AppThemeType.classicDark:
            return 'Oscuro Clásico';
          case AppThemeType.midnight:
            return 'Azul Medianoche';
          case AppThemeType.cyberPurple:
            return 'Púrpura Cyber';
          case AppThemeType.forestEmerald:
            return 'Esmeralda Bosque';
          case AppThemeType.sunsetAmber:
            return 'Ámbar Atardecer';
          case AppThemeType.roseElegance:
            return 'Rosa Elegancia';
          case AppThemeType.monochrome:
            return 'Monocromático';
          case AppThemeType.pureLight:
            return 'Blanco Puro';
          case AppThemeType.sakuraBloom:
            return 'Flor de Cerezo';
          case AppThemeType.mintFresh:
            return 'Menta Fresca';
          case AppThemeType.citrusSunny:
            return 'Cítrico Soleado';
          case AppThemeType.skyLavender:
            return 'Lavanda Cielo';
          case AppThemeType.cafeLatte:
            return 'Café Latte';
        }
      default:
        switch (this) {
          case AppThemeType.classicDark:
            return 'Classic Dark';
          case AppThemeType.midnight:
            return 'Midnight Blue';
          case AppThemeType.cyberPurple:
            return 'Cyber Purple';
          case AppThemeType.forestEmerald:
            return 'Forest Emerald';
          case AppThemeType.sunsetAmber:
            return 'Sunset Amber';
          case AppThemeType.roseElegance:
            return 'Rose Elegance';
          case AppThemeType.monochrome:
            return 'Monochrome';
          case AppThemeType.pureLight:
            return 'Pure Light';
          case AppThemeType.sakuraBloom:
            return 'Sakura Bloom';
          case AppThemeType.mintFresh:
            return 'Mint Fresh';
          case AppThemeType.citrusSunny:
            return 'Citrus Sunny';
          case AppThemeType.skyLavender:
            return 'Sky Lavender';
          case AppThemeType.cafeLatte:
            return 'Cafe Latte';
        }
    }
  }

  AppThemePalette get palette => AppThemePalette.ofThemeType(this);
}

@immutable
class AppThemePalette extends ThemeExtension<AppThemePalette> {
  const AppThemePalette({
    required this.themeType,
    required this.brightness,
    required this.background,
    required this.surface,
    required this.cardBackground,
    required this.textPrimary,
    required this.textLight,
    required this.textMuted,
    required this.primary,
    required this.accent,
    required this.success,
    required this.danger,
    required this.deleteKey,
    required this.deleteKeyForeground,
    required this.operatorKey,
    required this.operatorKeyForeground,
    required this.equalKey,
    required this.equalKeyForeground,
    required this.normalKey,
    required this.normalKeyForeground,
    required this.softKey,
    required this.softKeyForeground,
    required this.unitKey,
    required this.unitKeyForeground,
    required this.unitKeyActive,
    required this.unitKeyActiveForeground,
    required this.unitBorder,
    required this.historyGradientStart,
    required this.historyGradientEnd,
    required this.historySummaryIcon,
    required this.syntaxUnit,
    required this.syntaxOperator,
    required this.dividerColor,
    required this.cardBorder,
    required this.previewChips,
  });

  final AppThemeType themeType;
  final Brightness brightness;
  final Color background;
  final Color surface;
  final Color cardBackground;
  final Color textPrimary;
  final Color textLight;
  final Color textMuted;
  final Color primary;
  final Color accent;
  final Color success;
  final Color danger;
  final Color deleteKey;
  final Color deleteKeyForeground;
  final Color operatorKey;
  final Color operatorKeyForeground;
  final Color equalKey;
  final Color equalKeyForeground;
  final Color normalKey;
  final Color normalKeyForeground;
  final Color softKey;
  final Color softKeyForeground;
  final Color unitKey;
  final Color unitKeyForeground;
  final Color unitKeyActive;
  final Color unitKeyActiveForeground;
  final Color unitBorder;
  final Color historyGradientStart;
  final Color historyGradientEnd;
  final Color historySummaryIcon;
  final Color syntaxUnit;
  final Color syntaxOperator;
  final Color dividerColor;
  final Color cardBorder;
  final List<Color> previewChips;

  static AppThemePalette of(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemePalette>();
    return ext ?? classicDark;
  }

  static AppThemePalette ofTheme(ThemeData theme) {
    return theme.extension<AppThemePalette>() ?? classicDark;
  }

  static AppThemePalette ofThemeType(AppThemeType type) {
    switch (type) {
      case AppThemeType.classicDark:
        return classicDark;
      case AppThemeType.midnight:
        return midnight;
      case AppThemeType.cyberPurple:
        return cyberPurple;
      case AppThemeType.forestEmerald:
        return forestEmerald;
      case AppThemeType.sunsetAmber:
        return sunsetAmber;
      case AppThemeType.roseElegance:
        return roseElegance;
      case AppThemeType.monochrome:
        return monochrome;
      case AppThemeType.pureLight:
        return pureLight;
      case AppThemeType.sakuraBloom:
        return sakuraBloom;
      case AppThemeType.mintFresh:
        return mintFresh;
      case AppThemeType.citrusSunny:
        return citrusSunny;
      case AppThemeType.skyLavender:
        return skyLavender;
      case AppThemeType.cafeLatte:
        return cafeLatte;
    }
  }

  // 1. Classic Dark
  static const AppThemePalette classicDark = AppThemePalette(
    themeType: AppThemeType.classicDark,
    brightness: Brightness.dark,
    background: Color(0xFF0D0F14),
    surface: Color(0xFF181B22),
    cardBackground: Color(0xFF181B22),
    textPrimary: Colors.white,
    textLight: Color(0xFFCFD8DC),
    textMuted: Color(0xFFB0BEC5),
    primary: Color(0xFF2575FC),
    accent: Color(0xFFF89B13),
    success: Color(0xFF2ECC71),
    danger: Color(0xFFFF6B6B),
    deleteKey: Color(0xFFC0392B),
    deleteKeyForeground: Colors.white,
    operatorKey: Color(0xFFE67E22),
    operatorKeyForeground: Colors.white,
    equalKey: Color(0xFF2575FC),
    equalKeyForeground: Colors.white,
    normalKey: Color(0xFF2A2D32),
    normalKeyForeground: Colors.white,
    softKey: Color(0xFF3D4148),
    softKeyForeground: Color(0xFFFF6B6B),
    unitKey: Color(0xFF1E4334),
    unitKeyForeground: Color(0xFFD4ECD0),
    unitKeyActive: Color(0xFF27AE60),
    unitKeyActiveForeground: Colors.white,
    unitBorder: Color(0xFF2E6B50),
    historyGradientStart: Color(0xFF1B2A4A),
    historyGradientEnd: Color(0xFF244A7E),
    historySummaryIcon: Color(0xFF64B5F6),
    syntaxUnit: Color(0xFF81C784),
    syntaxOperator: Color(0xFFFFB74D),
    dividerColor: Colors.white12,
    cardBorder: Colors.white10,
    previewChips: [
      Color(0xFF0D0F14),
      Color(0xFFE67E22),
      Color(0xFF2575FC),
      Color(0xFF27AE60),
    ],
  );

  // 2. Midnight Blue
  static const AppThemePalette midnight = AppThemePalette(
    themeType: AppThemeType.midnight,
    brightness: Brightness.dark,
    background: Color(0xFF0A0F1D),
    surface: Color(0xFF141D36),
    cardBackground: Color(0xFF141D36),
    textPrimary: Colors.white,
    textLight: Color(0xFFD2E4F6),
    textMuted: Color(0xFF8FA3BF),
    primary: Color(0xFF38BDF8),
    accent: Color(0xFF00D2FF),
    success: Color(0xFF34D399),
    danger: Color(0xFFF87171),
    deleteKey: Color(0xFFDC2626),
    deleteKeyForeground: Colors.white,
    operatorKey: Color(0xFF2563EB),
    operatorKeyForeground: Colors.white,
    equalKey: Color(0xFF00B4D8),
    equalKeyForeground: Color(0xFF04152D),
    normalKey: Color(0xFF1E2B4D),
    normalKeyForeground: Colors.white,
    softKey: Color(0xFF283863),
    softKeyForeground: Color(0xFF60A5FA),
    unitKey: Color(0xFF0F3460),
    unitKeyForeground: Color(0xFFBAE6FD),
    unitKeyActive: Color(0xFF0284C7),
    unitKeyActiveForeground: Colors.white,
    unitBorder: Color(0xFF38BDF8),
    historyGradientStart: Color(0xFF0F172A),
    historyGradientEnd: Color(0xFF1E3A8A),
    historySummaryIcon: Color(0xFF38BDF8),
    syntaxUnit: Color(0xFF38BDF8),
    syntaxOperator: Color(0xFF93C5FD),
    dividerColor: Color(0x2238BDF8),
    cardBorder: Color(0x1F38BDF8),
    previewChips: [
      Color(0xFF0A0F1D),
      Color(0xFF2563EB),
      Color(0xFF00B4D8),
      Color(0xFF0284C7),
    ],
  );

  // 3. Cyber Purple
  static const AppThemePalette cyberPurple = AppThemePalette(
    themeType: AppThemeType.cyberPurple,
    brightness: Brightness.dark,
    background: Color(0xFF0F0A1A),
    surface: Color(0xFF1D1333),
    cardBackground: Color(0xFF1D1333),
    textPrimary: Colors.white,
    textLight: Color(0xFFE9D5FF),
    textMuted: Color(0xFFA899C2),
    primary: Color(0xFFC084FC),
    accent: Color(0xFFE879F9),
    success: Color(0xFF34D399),
    danger: Color(0xFFFB7185),
    deleteKey: Color(0xFFBE185D),
    deleteKeyForeground: Colors.white,
    operatorKey: Color(0xFF9333EA),
    operatorKeyForeground: Colors.white,
    equalKey: Color(0xFFC026D3),
    equalKeyForeground: Colors.white,
    normalKey: Color(0xFF291B47),
    normalKeyForeground: Colors.white,
    softKey: Color(0xFF3E2666),
    softKeyForeground: Color(0xFFF472B6),
    unitKey: Color(0xFF361457),
    unitKeyForeground: Color(0xFFF5D0FE),
    unitKeyActive: Color(0xFFA855F7),
    unitKeyActiveForeground: Colors.white,
    unitBorder: Color(0xFFD946EF),
    historyGradientStart: Color(0xFF2E1065),
    historyGradientEnd: Color(0xFF581C87),
    historySummaryIcon: Color(0xFFE879F9),
    syntaxUnit: Color(0xFFF472B6),
    syntaxOperator: Color(0xFFC084FC),
    dividerColor: Color(0x22C084FC),
    cardBorder: Color(0x1FC084FC),
    previewChips: [
      Color(0xFF0F0A1A),
      Color(0xFF9333EA),
      Color(0xFFC026D3),
      Color(0xFFA855F7),
    ],
  );

  // 4. Forest Emerald
  static const AppThemePalette forestEmerald = AppThemePalette(
    themeType: AppThemeType.forestEmerald,
    brightness: Brightness.dark,
    background: Color(0xFF09140E),
    surface: Color(0xFF11231A),
    cardBackground: Color(0xFF11231A),
    textPrimary: Colors.white,
    textLight: Color(0xFFD1FAE5),
    textMuted: Color(0xFF8EAA9B),
    primary: Color(0xFF34D399),
    accent: Color(0xFF10B981),
    success: Color(0xFF10B981),
    danger: Color(0xFFF87171),
    deleteKey: Color(0xFFB91C1C),
    deleteKeyForeground: Colors.white,
    operatorKey: Color(0xFF059669),
    operatorKeyForeground: Colors.white,
    equalKey: Color(0xFF0D9488),
    equalKeyForeground: Colors.white,
    normalKey: Color(0xFF183326),
    normalKeyForeground: Colors.white,
    softKey: Color(0xFF244A38),
    softKeyForeground: Color(0xFF6EE7B7),
    unitKey: Color(0xFF0E3D2A),
    unitKeyForeground: Color(0xFFA7F3D0),
    unitKeyActive: Color(0xFF10B981),
    unitKeyActiveForeground: Colors.white,
    unitBorder: Color(0xFF34D399),
    historyGradientStart: Color(0xFF064E3B),
    historyGradientEnd: Color(0xFF065F46),
    historySummaryIcon: Color(0xFF6EE7B7),
    syntaxUnit: Color(0xFF34D399),
    syntaxOperator: Color(0xFF6EE7B7),
    dividerColor: Color(0x2234D399),
    cardBorder: Color(0x1F34D399),
    previewChips: [
      Color(0xFF09140E),
      Color(0xFF059669),
      Color(0xFF0D9488),
      Color(0xFF10B981),
    ],
  );

  // 5. Sunset Amber
  static const AppThemePalette sunsetAmber = AppThemePalette(
    themeType: AppThemeType.sunsetAmber,
    brightness: Brightness.dark,
    background: Color(0xFF140C08),
    surface: Color(0xFF241710),
    cardBackground: Color(0xFF241710),
    textPrimary: Colors.white,
    textLight: Color(0xFFFFEDD5),
    textMuted: Color(0xFFBCA396),
    primary: Color(0xFFFB923C),
    accent: Color(0xFFF97316),
    success: Color(0xFF34D399),
    danger: Color(0xFFF87171),
    deleteKey: Color(0xFFBE123C),
    deleteKeyForeground: Colors.white,
    operatorKey: Color(0xFFEA580C),
    operatorKeyForeground: Colors.white,
    equalKey: Color(0xFFD97706),
    equalKeyForeground: Colors.white,
    normalKey: Color(0xFF352218),
    normalKeyForeground: Colors.white,
    softKey: Color(0xFF4C3023),
    softKeyForeground: Color(0xFFFCA5A5),
    unitKey: Color(0xFF382013),
    unitKeyForeground: Color(0xFFFED7AA),
    unitKeyActive: Color(0xFFF97316),
    unitKeyActiveForeground: Colors.white,
    unitBorder: Color(0xFFFB923C),
    historyGradientStart: Color(0xFF451A03),
    historyGradientEnd: Color(0xFF7C2D12),
    historySummaryIcon: Color(0xFFFB923C),
    syntaxUnit: Color(0xFFFDBA74),
    syntaxOperator: Color(0xFFFCD34D),
    dividerColor: Color(0x22FB923C),
    cardBorder: Color(0x1FFB923C),
    previewChips: [
      Color(0xFF140C08),
      Color(0xFFEA580C),
      Color(0xFFD97706),
      Color(0xFFF97316),
    ],
  );

  // 6. Rose Elegance
  static const AppThemePalette roseElegance = AppThemePalette(
    themeType: AppThemeType.roseElegance,
    brightness: Brightness.dark,
    background: Color(0xFF140910),
    surface: Color(0xFF24121E),
    cardBackground: Color(0xFF24121E),
    textPrimary: Colors.white,
    textLight: Color(0xFFFFE4E6),
    textMuted: Color(0xFFB595A6),
    primary: Color(0xFFFB7185),
    accent: Color(0xFFF43F5E),
    success: Color(0xFF34D399),
    danger: Color(0xFFFDA4AF),
    deleteKey: Color(0xFF9F1239),
    deleteKeyForeground: Colors.white,
    operatorKey: Color(0xFFE11D48),
    operatorKeyForeground: Colors.white,
    equalKey: Color(0xFFDB2777),
    equalKeyForeground: Colors.white,
    normalKey: Color(0xFF361B2E),
    normalKeyForeground: Colors.white,
    softKey: Color(0xFF4F2743),
    softKeyForeground: Color(0xFFFDA4AF),
    unitKey: Color(0xFF3A162D),
    unitKeyForeground: Color(0xFFFECDD3),
    unitKeyActive: Color(0xFFF43F5E),
    unitKeyActiveForeground: Colors.white,
    unitBorder: Color(0xFFFB7185),
    historyGradientStart: Color(0xFF4C0519),
    historyGradientEnd: Color(0xFF831843),
    historySummaryIcon: Color(0xFFFDA4AF),
    syntaxUnit: Color(0xFFFB7185),
    syntaxOperator: Color(0xFFF472B6),
    dividerColor: Color(0x22FB7185),
    cardBorder: Color(0x1FFB7185),
    previewChips: [
      Color(0xFF140910),
      Color(0xFFE11D48),
      Color(0xFFDB2777),
      Color(0xFFF43F5E),
    ],
  );

  // 7. Monochrome
  static const AppThemePalette monochrome = AppThemePalette(
    themeType: AppThemeType.monochrome,
    brightness: Brightness.dark,
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    cardBackground: Color(0xFF1E1E1E),
    textPrimary: Colors.white,
    textLight: Color(0xFFE0E0E0),
    textMuted: Color(0xFF9E9E9E),
    primary: Color(0xFFE0E0E0),
    accent: Colors.white,
    success: Color(0xFFBDBDBD),
    danger: Color(0xFFEF5350),
    deleteKey: Color(0xFF424242),
    deleteKeyForeground: Colors.white,
    operatorKey: Color(0xFF383838),
    operatorKeyForeground: Colors.white,
    equalKey: Colors.white,
    equalKeyForeground: Color(0xFF121212),
    normalKey: Color(0xFF262626),
    normalKeyForeground: Colors.white,
    softKey: Color(0xFF333333),
    softKeyForeground: Color(0xFFE0E0E0),
    unitKey: Color(0xFF282828),
    unitKeyForeground: Color(0xFFE0E0E0),
    unitKeyActive: Color(0xFF616161),
    unitKeyActiveForeground: Colors.white,
    unitBorder: Color(0xFF757575),
    historyGradientStart: Color(0xFF212121),
    historyGradientEnd: Color(0xFF333333),
    historySummaryIcon: Colors.white,
    syntaxUnit: Color(0xFFE0E0E0),
    syntaxOperator: Color(0xFFBDBDBD),
    dividerColor: Colors.white12,
    cardBorder: Colors.white10,
    previewChips: [
      Color(0xFF121212),
      Color(0xFF383838),
      Colors.white,
      Color(0xFF616161),
    ],
  );

  // 8. Pure Light
  static const AppThemePalette pureLight = AppThemePalette(
    themeType: AppThemeType.pureLight,
    brightness: Brightness.light,
    background: Color(0xFFF4F6F9),
    surface: Colors.white,
    cardBackground: Colors.white,
    textPrimary: Color(0xFF0F172A),
    textLight: Color(0xFF334155),
    textMuted: Color(0xFF64748B),
    primary: Color(0xFF2563EB),
    accent: Color(0xFF3B82F6),
    success: Color(0xFF10B981),
    danger: Color(0xFFEF4444),
    deleteKey: Color(0xFFFEE2E2),
    deleteKeyForeground: Color(0xFFB91C1C),
    operatorKey: Color(0xFFEFF6FF),
    operatorKeyForeground: Color(0xFF1D4ED8),
    equalKey: Color(0xFF2563EB),
    equalKeyForeground: Colors.white,
    normalKey: Colors.white,
    normalKeyForeground: Color(0xFF1E293B),
    softKey: Color(0xFFF1F5F9),
    softKeyForeground: Color(0xFFDC2626),
    unitKey: Color(0xFFECFDF5),
    unitKeyForeground: Color(0xFF065F46),
    unitKeyActive: Color(0xFF10B981),
    unitKeyActiveForeground: Colors.white,
    unitBorder: Color(0xFF6EE7B7),
    historyGradientStart: Color(0xFF1E3A8A),
    historyGradientEnd: Color(0xFF3B82F6),
    historySummaryIcon: Color(0xFF93C5FD),
    syntaxUnit: Color(0xFF059669),
    syntaxOperator: Color(0xFF2563EB),
    dividerColor: Color(0xFFE2E8F0),
    cardBorder: Color(0xFFCBD5E1),
    previewChips: [
      Color(0xFFF4F6F9),
      Color(0xFFEFF6FF),
      Color(0xFF2563EB),
      Color(0xFF10B981),
    ],
  );

  // 9. Sakura Bloom
  static const AppThemePalette sakuraBloom = AppThemePalette(
    themeType: AppThemeType.sakuraBloom,
    brightness: Brightness.light,
    background: Color(0xFFFFF5F7),
    surface: Colors.white,
    cardBackground: Color(0xFFFFF0F3),
    textPrimary: Color(0xFF1E293B),
    textLight: Color(0xFF475569),
    textMuted: Color(0xFF94A3B8),
    primary: Color(0xFFE11D48),
    accent: Color(0xFFF43F5E),
    success: Color(0xFF10B981),
    danger: Color(0xFFEF4444),
    deleteKey: Color(0xFFFFE4E6),
    deleteKeyForeground: Color(0xFFBE123C),
    operatorKey: Color(0xFFFCE7F3),
    operatorKeyForeground: Color(0xFFBE185D),
    equalKey: Color(0xFFE11D48),
    equalKeyForeground: Colors.white,
    normalKey: Colors.white,
    normalKeyForeground: Color(0xFF1E293B),
    softKey: Color(0xFFFFF1F2),
    softKeyForeground: Color(0xFFE11D48),
    unitKey: Color(0xFFFDF2F8),
    unitKeyForeground: Color(0xFF9D174D),
    unitKeyActive: Color(0xFFE11D48),
    unitKeyActiveForeground: Colors.white,
    unitBorder: Color(0xFFFBCFE8),
    historyGradientStart: Color(0xFFBE185D),
    historyGradientEnd: Color(0xFFFB7185),
    historySummaryIcon: Color(0xFFF472B6),
    syntaxUnit: Color(0xFFDB2777),
    syntaxOperator: Color(0xFFE11D48),
    dividerColor: Color(0xFFFCE7F3),
    cardBorder: Color(0xFFFBCFE8),
    previewChips: [
      Color(0xFFFFF5F7),
      Color(0xFFFCE7F3),
      Color(0xFFE11D48),
      Color(0xFFFB7185),
    ],
  );

  // 10. Mint Fresh
  static const AppThemePalette mintFresh = AppThemePalette(
    themeType: AppThemeType.mintFresh,
    brightness: Brightness.light,
    background: Color(0xFFF0FDF4),
    surface: Colors.white,
    cardBackground: Color(0xFFDCFCE7),
    textPrimary: Color(0xFF0F172A),
    textLight: Color(0xFF334155),
    textMuted: Color(0xFF64748B),
    primary: Color(0xFF059669),
    accent: Color(0xFF10B981),
    success: Color(0xFF10B981),
    danger: Color(0xFFEF4444),
    deleteKey: Color(0xFFFEE2E2),
    deleteKeyForeground: Color(0xFFB91C1C),
    operatorKey: Color(0xFFD1FAE5),
    operatorKeyForeground: Color(0xFF047857),
    equalKey: Color(0xFF059669),
    equalKeyForeground: Colors.white,
    normalKey: Colors.white,
    normalKeyForeground: Color(0xFF0F172A),
    softKey: Color(0xFFECFDF5),
    softKeyForeground: Color(0xFF059669),
    unitKey: Color(0xFFE6FFFA),
    unitKeyForeground: Color(0xFF0F766E),
    unitKeyActive: Color(0xFF0D9488),
    unitKeyActiveForeground: Colors.white,
    unitBorder: Color(0xFFA7F3D0),
    historyGradientStart: Color(0xFF065F46),
    historyGradientEnd: Color(0xFF10B981),
    historySummaryIcon: Color(0xFF6EE7B7),
    syntaxUnit: Color(0xFF0D9488),
    syntaxOperator: Color(0xFF059669),
    dividerColor: Color(0xFFD1FAE5),
    cardBorder: Color(0xFFA7F3D0),
    previewChips: [
      Color(0xFFF0FDF4),
      Color(0xFFD1FAE5),
      Color(0xFF059669),
      Color(0xFF10B981),
    ],
  );

  // 11. Citrus Sunny
  static const AppThemePalette citrusSunny = AppThemePalette(
    themeType: AppThemeType.citrusSunny,
    brightness: Brightness.light,
    background: Color(0xFFFFFBEB),
    surface: Colors.white,
    cardBackground: Color(0xFFFEF3C7),
    textPrimary: Color(0xFF1C1917),
    textLight: Color(0xFF44403C),
    textMuted: Color(0xFF78716C),
    primary: Color(0xFFEA580C),
    accent: Color(0xFFF59E0B),
    success: Color(0xFF16A34A),
    danger: Color(0xFFDC2626),
    deleteKey: Color(0xFFFFEDD5),
    deleteKeyForeground: Color(0xFFC2410C),
    operatorKey: Color(0xFFFEF3C7),
    operatorKeyForeground: Color(0xFFB45309),
    equalKey: Color(0xFFEA580C),
    equalKeyForeground: Colors.white,
    normalKey: Colors.white,
    normalKeyForeground: Color(0xFF1C1917),
    softKey: Color(0xFFFFF7ED),
    softKeyForeground: Color(0xFFEA580C),
    unitKey: Color(0xFFFEF9C3),
    unitKeyForeground: Color(0xFF854D0E),
    unitKeyActive: Color(0xFFD97706),
    unitKeyActiveForeground: Colors.white,
    unitBorder: Color(0xFFFDE68A),
    historyGradientStart: Color(0xFF9A3412),
    historyGradientEnd: Color(0xFFF59E0B),
    historySummaryIcon: Color(0xFFFBBF24),
    syntaxUnit: Color(0xFFD97706),
    syntaxOperator: Color(0xFFEA580C),
    dividerColor: Color(0xFFFDE68A),
    cardBorder: Color(0xFFFDE68A),
    previewChips: [
      Color(0xFFFFFBEB),
      Color(0xFFFEF3C7),
      Color(0xFFEA580C),
      Color(0xFFF59E0B),
    ],
  );

  // 12. Sky Lavender
  static const AppThemePalette skyLavender = AppThemePalette(
    themeType: AppThemeType.skyLavender,
    brightness: Brightness.light,
    background: Color(0xFFF8F7FF),
    surface: Colors.white,
    cardBackground: Color(0xFFEDE9FE),
    textPrimary: Color(0xFF1E1B4B),
    textLight: Color(0xFF4338CA),
    textMuted: Color(0xFF6B7280),
    primary: Color(0xFF7C3AED),
    accent: Color(0xFF6366F1),
    success: Color(0xFF10B981),
    danger: Color(0xFFEF4444),
    deleteKey: Color(0xFFFEE2E2),
    deleteKeyForeground: Color(0xFFB91C1C),
    operatorKey: Color(0xFFEDE9FE),
    operatorKeyForeground: Color(0xFF6D28D9),
    equalKey: Color(0xFF7C3AED),
    equalKeyForeground: Colors.white,
    normalKey: Colors.white,
    normalKeyForeground: Color(0xFF1E1B4B),
    softKey: Color(0xFFF5F3FF),
    softKeyForeground: Color(0xFF7C3AED),
    unitKey: Color(0xFFE0E7FF),
    unitKeyForeground: Color(0xFF3730A3),
    unitKeyActive: Color(0xFF6366F1),
    unitKeyActiveForeground: Colors.white,
    unitBorder: Color(0xFFDDD6FE),
    historyGradientStart: Color(0xFF4C1D95),
    historyGradientEnd: Color(0xFF7C3AED),
    historySummaryIcon: Color(0xFFA78BFA),
    syntaxUnit: Color(0xFF6366F1),
    syntaxOperator: Color(0xFF7C3AED),
    dividerColor: Color(0xFFE0E7FF),
    cardBorder: Color(0xFFDDD6FE),
    previewChips: [
      Color(0xFFF8F7FF),
      Color(0xFFEDE9FE),
      Color(0xFF7C3AED),
      Color(0xFF6366F1),
    ],
  );

  // 13. Cafe Latte
  static const AppThemePalette cafeLatte = AppThemePalette(
    themeType: AppThemeType.cafeLatte,
    brightness: Brightness.light,
    background: Color(0xFFFAF7F2),
    surface: Colors.white,
    cardBackground: Color(0xFFF3EDE4),
    textPrimary: Color(0xFF292524),
    textLight: Color(0xFF57534E),
    textMuted: Color(0xFF78716C),
    primary: Color(0xFF854D0E),
    accent: Color(0xFFB45309),
    success: Color(0xFF15803D),
    danger: Color(0xFFB91C1C),
    deleteKey: Color(0xFFFEE2E2),
    deleteKeyForeground: Color(0xFF991B1B),
    operatorKey: Color(0xFFEFE6DA),
    operatorKeyForeground: Color(0xFF78350F),
    equalKey: Color(0xFF854D0E),
    equalKeyForeground: Colors.white,
    normalKey: Colors.white,
    normalKeyForeground: Color(0xFF292524),
    softKey: Color(0xFFF7F3EC),
    softKeyForeground: Color(0xFF854D0E),
    unitKey: Color(0xFFE8E0D5),
    unitKeyForeground: Color(0xFF5A3E2B),
    unitKeyActive: Color(0xFF92400E),
    unitKeyActiveForeground: Colors.white,
    unitBorder: Color(0xFFD7C7B2),
    historyGradientStart: Color(0xFF543823),
    historyGradientEnd: Color(0xFF854D0E),
    historySummaryIcon: Color(0xFFD4B996),
    syntaxUnit: Color(0xFF92400E),
    syntaxOperator: Color(0xFF854D0E),
    dividerColor: Color(0xFFE7DFD5),
    cardBorder: Color(0xFFD7C7B2),
    previewChips: [
      Color(0xFFFAF7F2),
      Color(0xFFEFE6DA),
      Color(0xFF854D0E),
      Color(0xFFB45309),
    ],
  );

  @override
  AppThemePalette copyWith({
    AppThemeType? themeType,
    Brightness? brightness,
    Color? background,
    Color? surface,
    Color? cardBackground,
    Color? textPrimary,
    Color? textLight,
    Color? textMuted,
    Color? primary,
    Color? accent,
    Color? success,
    Color? danger,
    Color? deleteKey,
    Color? deleteKeyForeground,
    Color? operatorKey,
    Color? operatorKeyForeground,
    Color? equalKey,
    Color? equalKeyForeground,
    Color? normalKey,
    Color? normalKeyForeground,
    Color? softKey,
    Color? softKeyForeground,
    Color? unitKey,
    Color? unitKeyForeground,
    Color? unitKeyActive,
    Color? unitKeyActiveForeground,
    Color? unitBorder,
    Color? historyGradientStart,
    Color? historyGradientEnd,
    Color? historySummaryIcon,
    Color? syntaxUnit,
    Color? syntaxOperator,
    Color? dividerColor,
    Color? cardBorder,
    List<Color>? previewChips,
  }) {
    return AppThemePalette(
      themeType: themeType ?? this.themeType,
      brightness: brightness ?? this.brightness,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      cardBackground: cardBackground ?? this.cardBackground,
      textPrimary: textPrimary ?? this.textPrimary,
      textLight: textLight ?? this.textLight,
      textMuted: textMuted ?? this.textMuted,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      deleteKey: deleteKey ?? this.deleteKey,
      deleteKeyForeground: deleteKeyForeground ?? this.deleteKeyForeground,
      operatorKey: operatorKey ?? this.operatorKey,
      operatorKeyForeground: operatorKeyForeground ?? this.operatorKeyForeground,
      equalKey: equalKey ?? this.equalKey,
      equalKeyForeground: equalKeyForeground ?? this.equalKeyForeground,
      normalKey: normalKey ?? this.normalKey,
      normalKeyForeground: normalKeyForeground ?? this.normalKeyForeground,
      softKey: softKey ?? this.softKey,
      softKeyForeground: softKeyForeground ?? this.softKeyForeground,
      unitKey: unitKey ?? this.unitKey,
      unitKeyForeground: unitKeyForeground ?? this.unitKeyForeground,
      unitKeyActive: unitKeyActive ?? this.unitKeyActive,
      unitKeyActiveForeground: unitKeyActiveForeground ?? this.unitKeyActiveForeground,
      unitBorder: unitBorder ?? this.unitBorder,
      historyGradientStart: historyGradientStart ?? this.historyGradientStart,
      historyGradientEnd: historyGradientEnd ?? this.historyGradientEnd,
      historySummaryIcon: historySummaryIcon ?? this.historySummaryIcon,
      syntaxUnit: syntaxUnit ?? this.syntaxUnit,
      syntaxOperator: syntaxOperator ?? this.syntaxOperator,
      dividerColor: dividerColor ?? this.dividerColor,
      cardBorder: cardBorder ?? this.cardBorder,
      previewChips: previewChips ?? this.previewChips,
    );
  }

  @override
  AppThemePalette lerp(
    covariant ThemeExtension<AppThemePalette>? other,
    double t,
  ) {
    if (other is! AppThemePalette) return this;
    return AppThemePalette(
      themeType: t < 0.5 ? themeType : other.themeType,
      brightness: t < 0.5 ? brightness : other.brightness,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textLight: Color.lerp(textLight, other.textLight, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      deleteKey: Color.lerp(deleteKey, other.deleteKey, t)!,
      deleteKeyForeground: Color.lerp(deleteKeyForeground, other.deleteKeyForeground, t)!,
      operatorKey: Color.lerp(operatorKey, other.operatorKey, t)!,
      operatorKeyForeground: Color.lerp(operatorKeyForeground, other.operatorKeyForeground, t)!,
      equalKey: Color.lerp(equalKey, other.equalKey, t)!,
      equalKeyForeground: Color.lerp(equalKeyForeground, other.equalKeyForeground, t)!,
      normalKey: Color.lerp(normalKey, other.normalKey, t)!,
      normalKeyForeground: Color.lerp(normalKeyForeground, other.normalKeyForeground, t)!,
      softKey: Color.lerp(softKey, other.softKey, t)!,
      softKeyForeground: Color.lerp(softKeyForeground, other.softKeyForeground, t)!,
      unitKey: Color.lerp(unitKey, other.unitKey, t)!,
      unitKeyForeground: Color.lerp(unitKeyForeground, other.unitKeyForeground, t)!,
      unitKeyActive: Color.lerp(unitKeyActive, other.unitKeyActive, t)!,
      unitKeyActiveForeground: Color.lerp(unitKeyActiveForeground, other.unitKeyActiveForeground, t)!,
      unitBorder: Color.lerp(unitBorder, other.unitBorder, t)!,
      historyGradientStart: Color.lerp(historyGradientStart, other.historyGradientStart, t)!,
      historyGradientEnd: Color.lerp(historyGradientEnd, other.historyGradientEnd, t)!,
      historySummaryIcon: Color.lerp(historySummaryIcon, other.historySummaryIcon, t)!,
      syntaxUnit: Color.lerp(syntaxUnit, other.syntaxUnit, t)!,
      syntaxOperator: Color.lerp(syntaxOperator, other.syntaxOperator, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      previewChips: t < 0.5 ? previewChips : other.previewChips,
    );
  }
}
