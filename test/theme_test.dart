import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timecalculator/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Color Theme & AppThemePalette Tests', () {
    test('All 13 AppThemeType enum values have valid palettes and preview chips', () {
      expect(AppThemeType.values.length, 13);

      final lightCount = AppThemeType.values.where((t) => t.isLight).length;
      final darkCount = AppThemeType.values.where((t) => !t.isLight).length;
      expect(darkCount, 7);
      expect(lightCount, 6);

      for (final type in AppThemeType.values) {
        final palette = type.palette;
        expect(palette.themeType, type);
        expect(palette.background, isNotNull);
        expect(palette.surface, isNotNull);
        expect(palette.cardBackground, isNotNull);
        expect(palette.primary, isNotNull);
        expect(palette.accent, isNotNull);
        expect(palette.operatorKey, isNotNull);
        expect(palette.equalKey, isNotNull);
        expect(palette.normalKey, isNotNull);
        expect(palette.unitKey, isNotNull);
        expect(palette.deleteKey, isNotNull);
        expect(palette.previewChips.length, 4);

        if (type.isLight) {
          expect(palette.brightness, Brightness.light);
        } else {
          expect(palette.brightness, Brightness.dark);
        }

        // 各言語のテーマ表示名
        expect(type.getLocalizedName('ja').isNotEmpty, isTrue);
        expect(type.getLocalizedName('en').isNotEmpty, isTrue);
        expect(type.getLocalizedName('zh').isNotEmpty, isTrue);
        expect(type.getLocalizedName('ko').isNotEmpty, isTrue);
        expect(type.getLocalizedName('es').isNotEmpty, isTrue);

        // buildTheme検証
        final themeData = buildTheme(palette);
        expect(themeData.brightness, palette.brightness);
        expect(themeData.scaffoldBackgroundColor, palette.background);
        expect(themeData.extension<AppThemePalette>(), isNotNull);
        expect(themeData.extension<AppThemePalette>()!.themeType, type);
      }
    });

    test('AppThemeType.fromId falls back to classicDark for unknown or empty id', () {
      expect(AppThemeType.fromId(null), AppThemeType.classicDark);
      expect(AppThemeType.fromId(''), AppThemeType.classicDark);
      expect(AppThemeType.fromId('unknown_theme'), AppThemeType.classicDark);
      expect(AppThemeType.fromId('midnight'), AppThemeType.midnight);
      expect(AppThemeType.fromId('cyber_purple'), AppThemeType.cyberPurple);
      expect(AppThemeType.fromId('pure_light'), AppThemeType.pureLight);
      expect(AppThemeType.fromId('sakura_bloom'), AppThemeType.sakuraBloom);
      expect(AppThemeType.fromId('mint_fresh'), AppThemeType.mintFresh);
      expect(AppThemeType.fromId('citrus_sunny'), AppThemeType.citrusSunny);
      expect(AppThemeType.fromId('sky_lavender'), AppThemeType.skyLavender);
      expect(AppThemeType.fromId('cafe_latte'), AppThemeType.cafeLatte);
    });

    test('AppThemePalette lerp behaves correctly', () {
      const p1 = AppThemePalette.classicDark;
      const p2 = AppThemePalette.pureLight;

      final lerpedHalf = p1.lerp(p2, 0.5);
      expect(lerpedHalf.themeType, AppThemeType.pureLight);

      final lerpedZero = p1.lerp(p2, 0.0);
      expect(lerpedZero.themeType, AppThemeType.classicDark);
    });
  });

  group('Settings Screen Theme Switching Widget Tests', () {
    testWidgets('Settings screen shows color theme and allows changing theme', (tester) async {
      final settings = AppSettings();
      await settings.load();

      final storage = HistoryStorage();
      await storage.load();

      await tester.pumpWidget(
        TimeCalculatorApp(storage: storage, settings: settings),
      );
      await tester.pumpAndSettle();

      // 設定画面を開く
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      // 設定画面のタイトルとカラーテーマタイルを確認
      expect(find.text('設定'), findsOneWidget);
      expect(find.text('カラーテーマ'), findsOneWidget);
      expect(find.text('クラシックダーク'), findsOneWidget);

      // カラーテーマ設定をタップしてテーマ選択ダイアログを開く
      await tester.tap(find.text('カラーテーマ'));
      await tester.pumpAndSettle();

      // セクションヘッダーが表示されていることを確認
      expect(find.text('ダークテーマ'), findsOneWidget);
      expect(find.text('ライトテーマ'), findsOneWidget);

      // ダイアログ内に各テーマ名が表示されていることを確認
      expect(find.text('ミッドナイトブルー'), findsOneWidget);
      expect(find.text('サイバーパープル'), findsOneWidget);
      expect(find.text('フォレストエメラルド'), findsOneWidget);

      // 「ミッドナイトブルー」を選択
      await tester.tap(find.text('ミッドナイトブルー'));
      await tester.pumpAndSettle();

      // ダイアログが閉じ、設定のテーマがミッドナイトブルーに更新されていることを確認
      expect(settings.themeType, AppThemeType.midnight);
      expect(find.text('ミッドナイトブルー'), findsOneWidget);

      // 設定画面を閉じて電卓画面に戻る
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // 電卓画面でもテーマが反映されていることを確認
      expect(Theme.of(tester.element(find.byType(Scaffold))).scaffoldBackgroundColor, AppThemePalette.midnight.background);
    });

    testWidgets('Switching to Pure Light mode switches theme brightness to light', (tester) async {
      final settings = AppSettings();
      await settings.load();

      final storage = HistoryStorage();
      await storage.load();

      await tester.pumpWidget(
        TimeCalculatorApp(storage: storage, settings: settings),
      );
      await tester.pumpAndSettle();

      // 設定画面を開く
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      // テーマダイアログを開く
      await tester.tap(find.text('カラーテーマ'));
      await tester.pumpAndSettle();

      // ピュアライトを選択
      await tester.scrollUntilVisible(
        find.text('ピュアライト'),
        100.0,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('ピュアライト'));
      await tester.pumpAndSettle();

      expect(settings.themeType, AppThemeType.pureLight);
      expect(settings.palette.brightness, Brightness.light);

      // 戻る
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(Theme.of(tester.element(find.byType(Scaffold))).brightness, Brightness.light);
      expect(Theme.of(tester.element(find.byType(Scaffold))).scaffoldBackgroundColor, AppThemePalette.pureLight.background);
    });

    testWidgets('Switching to Sakura Bloom mode applies sakuraBloom theme', (tester) async {
      final settings = AppSettings();
      await settings.load();

      final storage = HistoryStorage();
      await storage.load();

      await tester.pumpWidget(
        TimeCalculatorApp(storage: storage, settings: settings),
      );
      await tester.pumpAndSettle();

      // 設定画面を開く
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      // テーマダイアログを開く
      await tester.tap(find.text('カラーテーマ'));
      await tester.pumpAndSettle();

      // サクラブルームを選択
      await tester.scrollUntilVisible(
        find.text('サクラブルーム'),
        100.0,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('サクラブルーム'));
      await tester.pumpAndSettle();

      expect(settings.themeType, AppThemeType.sakuraBloom);
      expect(settings.palette.brightness, Brightness.light);
      expect(find.text('サクラブルーム'), findsOneWidget);

      // 戻る
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(Theme.of(tester.element(find.byType(Scaffold))).brightness, Brightness.light);
      expect(Theme.of(tester.element(find.byType(Scaffold))).scaffoldBackgroundColor, AppThemePalette.sakuraBloom.background);
    });
  });
}
