import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timecalculator/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('P1: Whitespace & Full-width Space Normalization Tests', () {
    final parser = TimeExpressionParser();

    test('parses expression with full-width space correctly', () {
      final res = parser.evaluate('1時間　+　30分');
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, 5400);
      expect(res.displayText, '1時間30分');
    });

    test('parses expression with tabs and newlines correctly', () {
      final res = parser.evaluate("2時間\t+\n45分");
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, 9900);
      expect(res.displayText, '2時間45分');
    });

    test('tokenizer skips internal whitespace safely', () {
      final tokens = Tokenizer(" 5 \t 時間 \u3000 + 10 分 \n ").tokenize();
      expect(tokens.length, 5); // 5, 時間, +, 10, 分
    });
  });

  group('P2: HistoryStorage Max Capacity & Corruption Fallback Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('limits history records to maxRecords (200) on upsert', () async {
      final storage = HistoryStorage();
      await storage.load();

      for (var i = 0; i < 210; i++) {
        await storage.upsert(
          CalculationRecord(
            id: 'id_$i',
            expression: '$i時間',
            resultText: '$i時間',
            createdAt: DateTime.now().add(Duration(seconds: i)),
          ),
        );
      }

      expect(storage.records.length, HistoryStorage.maxRecords);
      expect(storage.records.length, 200);
      // 最新のレコード（id_209）が先頭にあること
      expect(storage.records.first.id, 'id_209');
    });

    test('skips corrupted JSON records gracefully during load', () async {
      final prefs = await SharedPreferences.getInstance();
      final validRecord = CalculationRecord(
        id: 'valid_1',
        expression: '1時間 + 30分',
        resultText: '1時間30分',
        createdAt: DateTime.now(),
      );
      final rawList = [
        jsonEncode(validRecord.toJson()),
        'INVALID_JSON_DATA_CORRUPTED{',
        '{"id": 123}', // スキーマ不一致（idがint）
        jsonEncode(
          CalculationRecord(
            id: 'valid_2',
            expression: '2時間',
            resultText: '2時間',
            createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          ).toJson(),
        ),
      ];
      await prefs.setStringList('records', rawList);

      final storage = HistoryStorage();
      await storage.load();

      // 不正データ2件がスキップされ、正常な2件のみ読み込まれること
      expect(storage.records.length, 2);
      expect(storage.records.map((r) => r.id), containsAll(['valid_1', 'valid_2']));
    });
  });

  group('P2: Multilingual Space Separator Tests', () {
    test('Japanese has no space between units', () {
      final ja = AppStrings.get(AppLanguage.japanese);
      expect(TimeFormatter.formatDuration(5400, ja.units), '1時間30分');
      expect(TimeFormatter.formatDuration(90000, ja.units), '1日1時間');
    });

    test('English uses space between units', () {
      final en = AppStrings.get(AppLanguage.english);
      expect(TimeFormatter.formatDuration(5400, en.units), '1hr 30min');
      expect(TimeFormatter.formatDuration(90000, en.units), '1d 1hr');
    });

    test('Spanish uses space between units', () {
      final es = AppStrings.get(AppLanguage.spanish);
      expect(TimeFormatter.formatDuration(5400, es.units), '1h 30min');
    });
  });

  group('P3: KeypadButton FittedBox and Semantics Widget Tests', () {
    testWidgets('KeypadButton renders with Semantics and FittedBox', (WidgetTester tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadButton(
              label: '時間',
              semanticsLabel: '時間単位',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // FittedBox が存在すること
      expect(find.byType(FittedBox), findsOneWidget);
      // ラベルテキストが表示されていること
      expect(find.text('時間'), findsOneWidget);

      // Semantics に semanticsLabel が設定されていること
      final semanticsFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == '時間単位',
      );
      expect(semanticsFinder, findsOneWidget);

      // タップできること
      await tester.tap(find.byType(KeypadButton));
      expect(tapped, isTrue);
    });
  });
}
