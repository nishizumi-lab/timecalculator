import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timecalculator/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Multilingual AppStrings & AppLanguage (31 Languages) Tests', () {
    test('All AppLanguage enum entries resolve valid AppStrings', () {
      expect(AppLanguage.values.length, 32); // 31 languages + system
      for (final lang in AppLanguage.values) {
        final strings = AppStrings.get(lang);
        expect(strings.appTitle.isNotEmpty, isTrue, reason: 'appTitle for ${lang.code}');
        expect(strings.units.year.isNotEmpty, isTrue, reason: 'units.year for ${lang.code}');
        expect(strings.units.month.isNotEmpty, isTrue, reason: 'units.month for ${lang.code}');
        expect(strings.units.week.isNotEmpty, isTrue, reason: 'units.week for ${lang.code}');
        expect(strings.units.day.isNotEmpty, isTrue, reason: 'units.day for ${lang.code}');
        expect(strings.units.hour.isNotEmpty, isTrue, reason: 'units.hour for ${lang.code}');
        expect(strings.units.minute.isNotEmpty, isTrue, reason: 'units.minute for ${lang.code}');
        expect(strings.units.second.isNotEmpty, isTrue, reason: 'units.second for ${lang.code}');
        expect(strings.history.isNotEmpty, isTrue, reason: 'history for ${lang.code}');
        expect(strings.settings.isNotEmpty, isTrue, reason: 'settings for ${lang.code}');
        expect(strings.language.isNotEmpty, isTrue, reason: 'language for ${lang.code}');
      }
    });

    test('Bengali AppStrings verification', () {
      final bn = AppStrings.get(AppLanguage.bengali);
      expect(bn.appTitle, 'সময় ক্যালকুলেটর');
      expect(bn.units.hour, 'ঘণ্টা');
      expect(bn.units.minute, 'মিনিট');
      expect(bn.history, 'ইতিহাস');
    });

    test('Swedish AppStrings verification', () {
      final sv = AppStrings.get(AppLanguage.swedish);
      expect(sv.appTitle, 'Tidskalkylator');
      expect(sv.units.hour, 'tim');
      expect(sv.units.minute, 'min');
      expect(sv.history, 'Historik');
    });

    test('Ukrainian AppStrings verification', () {
      final uk = AppStrings.get(AppLanguage.ukrainian);
      expect(uk.appTitle, 'Калькулятор Часу');
      expect(uk.units.hour, 'год');
      expect(uk.units.minute, 'хв');
      expect(uk.history, 'Історія');
    });

    test('Greek AppStrings verification', () {
      final el = AppStrings.get(AppLanguage.greek);
      expect(el.appTitle, 'Αριθμομηχανή Χρόνου');
      expect(el.units.hour, 'ώρα');
      expect(el.units.minute, 'λεπτό');
      expect(el.history, 'Ιστορικό');
    });

    test('Hungarian AppStrings verification', () {
      final hu = AppStrings.get(AppLanguage.hungarian);
      expect(hu.appTitle, 'Időszámológép');
      expect(hu.units.hour, 'óra');
      expect(hu.units.minute, 'perc');
      expect(hu.history, 'Előzmények');
    });
  });

  group('Multilingual TimeExpressionParser All 31 Languages Tests', () {
    final parser = TimeExpressionParser();

    test('English units: 2hr + 30min evaluates to 9000 seconds', () {
      final res = parser.evaluate('2hr + 30min');
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, 9000.0);
    });

    test('Japanese units: 2時間 + 30分 evaluates to 9000 seconds', () {
      final res = parser.evaluate('2時間 + 30分');
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, 9000.0);
    });

    test('Bengali units: 2ঘণ্টা + 30মিনিট evaluates to 9000 seconds', () {
      final res = parser.evaluate('2ঘণ্টা + 30মিনিট');
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, 9000.0);
    });

    test('Swedish units: 2tim + 30min evaluates to 9000 seconds', () {
      final res = parser.evaluate('2tim + 30min');
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, 9000.0);
    });

    test('Norwegian units: 2t + 30min evaluates to 9000 seconds', () {
      final res = parser.evaluate('2t + 30min');
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, 9000.0);
    });

    test('Ukrainian units: 2год + 30хв evaluates to 9000 seconds', () {
      final res = parser.evaluate('2год + 30хв');
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, 9000.0);
    });

    test('Finnish units: 2t + 30min evaluates to 9000 seconds', () {
      final res = parser.evaluate('2t + 30min');
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, 9000.0);
    });

    test('Czech units: 2hod + 30min evaluates to 9000 seconds', () {
      final res = parser.evaluate('2hod + 30min');
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, 9000.0);
    });

    test('Greek units: 2ώρα + 30λεπτό evaluates to 9000 seconds', () {
      final res = parser.evaluate('2ώρα + 30λεπτό');
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, 9000.0);
    });

    test('Romanian units: 2oră + 30min evaluates to 9000 seconds', () {
      final res = parser.evaluate('2oră + 30min');
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, 9000.0);
    });

    test('Hungarian units: 2óra + 30perc evaluates to 9000 seconds', () {
      final res = parser.evaluate('2óra + 30perc');
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, 9000.0);
    });

    test('Filipino units: 2oras + 30min evaluates to 9000 seconds', () {
      final res = parser.evaluate('2oras + 30min');
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, 9000.0);
    });
  });

  group('AppSettings & Language Switching Widget Tests', () {
    testWidgets('Settings screen allows changing language to Swedish and updates UI', (tester) async {
      final settings = AppSettings();
      await settings.load();

      final storage = HistoryStorage();
      await storage.load();

      await tester.pumpWidget(
        TimeCalculatorApp(storage: storage, settings: settings),
      );
      await tester.pumpAndSettle();

      // 初期状態（日本語）の確認
      expect(find.text('時間計算機'), findsOneWidget);
      expect(find.text('時間'), findsOneWidget);
      expect(find.text('分'), findsOneWidget);

      // 設定画面を開く
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      expect(find.text('設定'), findsOneWidget);
      expect(find.text('言語'), findsOneWidget);

      // 言語選択ダイアログを開く
      await tester.tap(find.text('言語'));
      await tester.pumpAndSettle();

      expect(find.text('Svenska'), findsOneWidget);

      // Svenska をスクロールして表示・選択
      await tester.ensureVisible(find.text('Svenska'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Svenska'));
      await tester.pumpAndSettle();

      // 設定画面がスウェーデン語に即座に切り替わっていることを確認
      expect(find.text('Inställningar'), findsOneWidget);
      expect(find.text('Språk'), findsOneWidget);

      // 戻る
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // メイン画面のタイトルとキーパッドがスウェーデン語に切り替わっていることを確認
      expect(find.text('Tidskalkylator'), findsOneWidget);
      expect(find.text('tim'), findsOneWidget);
      expect(find.text('min'), findsOneWidget);
    });
  });
}
