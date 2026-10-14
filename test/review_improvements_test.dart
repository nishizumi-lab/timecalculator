import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timecalculator/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TimeFormatter formatDuration fractional seconds & edge cases', () {
    test('preserves fractional seconds when minutes or hours exist and wholeSeconds is 0', () {
      expect(TimeFormatter.formatDuration(60.5), '1分0.5秒');
      expect(TimeFormatter.formatDuration(3600.5), '1時間0.5秒');
      expect(TimeFormatter.formatDuration(86400.25), '1日0.25秒');
    });

    test('formats clean values without redundant fractional seconds', () {
      expect(TimeFormatter.formatDuration(0.7 * 3600), '42分');
      expect(TimeFormatter.formatDuration(1.1 * 3600), '1時間6分');
      expect(TimeFormatter.formatDuration(60), '1分');
      expect(TimeFormatter.formatDuration(3600), '1時間');
      expect(TimeFormatter.formatDuration(0), '0秒');
    });

    test('formats sub-second durations correctly', () {
      expect(TimeFormatter.formatDuration(0.5), '0.5秒');
      expect(TimeFormatter.formatDuration(0.125), '0.125秒');
      expect(TimeFormatter.formatDuration(-0.5), '-0.5秒');
    });

    test('formats complex durations with fractional seconds', () {
      expect(TimeFormatter.formatDuration(2520.36), '42分0.36秒');
      expect(TimeFormatter.formatDuration(3661.75), '1時間1分1.75秒');
    });
  });

  group('commitCalculation deduplication and repeated execution', () {
    late HistoryStorage storage;
    late AppSettings settings;
    late CalculatorController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = HistoryStorage();
      await storage.load();
      settings = AppSettings();
      await settings.load();
      controller = CalculatorController(storage: storage, settings: settings);
    });

    test('consecutive commitCalculation calls do not produce duplicate history records', () async {
      controller.appendText('1');
      controller.appendUnit('時間');
      controller.appendText('+');
      controller.appendText('30');
      controller.appendUnit('分');

      await controller.commitCalculation();
      expect(controller.state.history.length, 1);
      expect(controller.state.history.first.expression, '1時間+30分');
      expect(controller.state.history.first.resultText, '1時間30分');
      expect(controller.state.expression, '1時間30分');
      expect(controller.state.isEvaluated, isTrue);

      // 2回目・3回目の実行で履歴が増加せず、式が「1時間30分=1時間30分」に上書きされないことを検証
      await controller.commitCalculation();
      await controller.commitCalculation();
      expect(controller.state.history.length, 1);
      expect(controller.state.expression, '1時間30分');
    });

    test('deduplicates history when expression has omitted units', () async {
      controller.appendText('10');
      controller.appendUnit('分');
      controller.appendText('+');
      controller.appendText('5');

      await controller.commitCalculation();
      expect(controller.state.history.length, 1);

      // 再度コミットを試みても重複して追加されない
      await controller.commitCalculation();
      expect(controller.state.history.length, 1);
    });
  });

  group('Tokenizer and Parser Unicode minus support', () {
    test('tokenizes Unicode minus sign − (U+2212) as minus token', () {
      final tokenizer = Tokenizer('10−5');
      final tokens = tokenizer.tokenize();
      expect(tokens.length, 3);
      expect(tokens[0].type, TokenType.number);
      expect(tokens[0].lexeme, '10');
      expect(tokens[1].type, TokenType.minus);
      expect(tokens[1].lexeme, '-');
      expect(tokens[2].type, TokenType.number);
      expect(tokens[2].lexeme, '5');
    });

    test('evaluates expressions containing Unicode minus sign', () {
      final parser = TimeExpressionParser();
      final result = parser.evaluate('5時間−2時間');
      expect(result.isValid, isTrue);
      expect(result.value?.durationSeconds, 3 * 3600);
      expect(result.displayText, '3時間');
    });
  });

  group('Localization display formatting in EvaluationState', () {
    test('formats duration with English unit labels', () {
      final parser = TimeExpressionParser();
      final result = parser.evaluate('1h+30m');
      expect(result.isValid, isTrue);
      final enStrings = AppStrings.get(AppLanguage.english);
      expect(result.formatDisplayText(enStrings.units), '1hr 30min');
    });

    test('formats duration with Spanish unit labels', () {
      final parser = TimeExpressionParser();
      final result = parser.evaluate('2h+15m');
      expect(result.isValid, isTrue);
      final esStrings = AppStrings.get(AppLanguage.spanish);
      expect(result.formatDisplayText(esStrings.units), '2h 15min');
    });
  });

  group('Compound units and Parser edge cases', () {
    test('uses finest/last unit for scalar addition in compound durations', () {
      final parser = TimeExpressionParser();
      // 1時間30分 に単位なしの 10 を足した場合、最後の単位「分」として 10分 が加算される
      final result = parser.evaluate('1時間30分+10');
      expect(result.isValid, isTrue);
      expect(result.value?.durationSeconds, 5400 + 600);
      expect(result.displayText, '1時間40分');
    });

    test('trims trailing operators including Unicode minus sign gracefully', () {
      final parser = TimeExpressionParser();
      final r1 = parser.evaluate('1時間+2時間−');
      expect(r1.isValid, isTrue);
      expect(r1.displayText, '3時間');

      final r2 = parser.evaluate('10分+×÷');
      expect(r2.isValid, isTrue);
      expect(r2.displayText, '10分');
    });

    test('appendUnit after evaluation clears evaluatedExpression', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = HistoryStorage();
      await storage.load();
      final settings = AppSettings();
      await settings.load();
      final controller =
          CalculatorController(storage: storage, settings: settings);

      controller.appendText('10');
      controller.appendUnit('分');
      await controller.commitCalculation();
      expect(controller.state.isEvaluated, isTrue);
      expect(controller.state.evaluatedExpression, '10分');

      // 評価後に数字と単位を入力
      controller.appendText('5');
      controller.appendUnit('分');
      expect(controller.state.isEvaluated, isFalse);
      expect(controller.state.evaluatedExpression, isNull);
    });

    test('resolves finer unit in _applyBinary for duration operations', () {
      final parser = TimeExpressionParser();
      // 1日+2時間 の結果は時間(hour)を unitSeconds として継承し、+10 は 10時間 が加算される
      final r1 = parser.evaluate('1日+2時間+10');
      expect(r1.isValid, isTrue);
      expect(r1.value?.durationSeconds, 86400 + 7200 + 36000);
      expect(r1.displayText, '1日12時間');

      // 2時間-30分 の結果は分(minute)を継承し、+10 は 10分 が加算される
      final r2 = parser.evaluate('2時間-30分+10');
      expect(r2.isValid, isTrue);
      expect(r2.value?.durationSeconds, 7200 - 1800 + 600);
      expect(r2.displayText, '1時間40分');
    });
  });

  group('normalizeExpressionUnits Safety Tests', () {
    test('does not append units across multiplication and division operands', () {
      expect(TimeFormatter.normalizeExpressionUnits('2×3日'), '2×3日');
      expect(TimeFormatter.normalizeExpressionUnits('3日×2'), '3日×2');
      expect(TimeFormatter.normalizeExpressionUnits('10分÷2'), '10分÷2');
      expect(TimeFormatter.normalizeExpressionUnits('1日+10×2'), '1日+10×2');
      expect(TimeFormatter.normalizeExpressionUnits('(1+2)×3日'), '(1+2)×3日');
    });

    test('preserves colon-based time in normalizeExpressionUnits', () {
      expect(TimeFormatter.normalizeExpressionUnits('1:30+10分'), '1:30+10分');
    });
  });

  group('Overflow and Finite Value Protection Tests', () {
    test('handles extreme large numbers and non-finite values safely without crashing', () {
      final parser = TimeExpressionParser();
      final huge = '1${'0' * 400}';
      final state1 = parser.evaluate('$huge秒');
      expect(state1.isValid, isFalse);

      final state2 = parser.evaluate('$huge秒-$huge秒');
      expect(state2.isValid, isFalse);

      final state3 = parser.evaluate('$huge÷$huge');
      expect(state3.isValid, isFalse);

      expect(TimeFormatter.formatDuration(double.infinity), '...');
      expect(TimeFormatter.formatDuration(double.nan), '...');
      expect(TimeFormatter.formatSummaryConversions(double.infinity), '...');
      expect(TimeFormatter.formatDecimal(double.infinity), 'Infinity');
    });

    test('re-evaluates large numbers in scientific notation after commitment without crash', () {
      final parser = TimeExpressionParser();
      final big = '10000000000000×10000000000000×10000000';
      final evaluated = parser.evaluate(big);
      expect(evaluated.isValid, isTrue);

      final text = evaluated.displayText;
      // 指数表記 1.0000000000000001e+33 の再評価が正常に行えること
      final reevaluated = parser.evaluate(text);
      expect(reevaluated.isValid, isTrue);
      expect(reevaluated.value?.scalar, isNotNull);
    });

    test('limits single number token length to 15 digits in keypad input', () {
      SharedPreferences.setMockInitialValues({});
      final storage = HistoryStorage();
      final settings = AppSettings();
      final controller =
          CalculatorController(storage: storage, settings: settings);

      for (var i = 0; i < 20; i++) {
        controller.appendText('9');
      }
      expect(controller.state.expression.length, 15);

      controller.appendText('+');
      for (var i = 0; i < 20; i++) {
        controller.appendText('1');
      }
      expect(controller.state.expression, '999999999999999+111111111111111');
    });
  });

  group('activeUnit Synchronization Tests', () {
    test('updates and clears activeUnit properly on unit, backspace, and clear', () {
      SharedPreferences.setMockInitialValues({});
      final storage = HistoryStorage();
      final settings = AppSettings();
      final controller =
          CalculatorController(storage: storage, settings: settings);

      controller.appendText('5');
      controller.appendUnit('時間');
      expect(controller.state.activeUnit, '時間');

      controller.backspace(); // 単位「時間」から「間」が消えて「5時」となり、有効な単位「時」になる
      expect(controller.state.activeUnit, '時');

      controller.backspace(); // 「時」が消えて「5」となり、単位なしになる
      expect(controller.state.activeUnit, isNull);

      controller.appendUnit('分');
      expect(controller.state.activeUnit, '分');

      controller.clear();
      expect(controller.state.activeUnit, isNull);
    });
  });

  group('Turkish saat and Malay dtk resolution', () {
    test('resolves Turkish saat as hour and Malay dtk as second', () {
      final parser = TimeExpressionParser();
      final turkish = parser.evaluate('2saat');
      expect(turkish.isValid, isTrue);
      expect(turkish.value?.durationSeconds, 2 * 3600);

      final malay = parser.evaluate('45dtk');
      expect(malay.isValid, isTrue);
      expect(malay.value?.durationSeconds, 45);
    });
  });

  group('formatDecimal scientific notation preservation', () {
    test('preserves scientific notation without stripping trailing exponent zeros', () {
      expect(TimeFormatter.formatDecimal(1e30), '1e+30');
      expect(TimeFormatter.formatDecimal(2e21), '2e+21');
      expect(TimeFormatter.formatDecimal(2e20), '200000000000000000000');
      expect(TimeFormatter.formatDecimal(12.34000), '12.34');
      expect(TimeFormatter.formatDecimal(100.0), '100');
    });
  });

  group('Duration overflow protection', () {
    test('rejects durationSeconds >= 1e18 with generalError to prevent VM int64 overflow', () {
      final parser = TimeExpressionParser();
      final overflowState = parser.evaluate('1e30秒');
      expect(overflowState.isValid, isFalse);
      expect(overflowState.errorCode, ParserErrorCode.generalError);

      final boundaryOverflow = parser.evaluate('1e18秒');
      expect(boundaryOverflow.isValid, isFalse);
      expect(boundaryOverflow.errorCode, ParserErrorCode.generalError);

      final safeState = parser.evaluate('1e17秒');
      expect(safeState.isValid, isTrue);
      expect(safeState.value?.durationSeconds, 1e17);
    });
  });

  group('All languages round-trip unit parsing regression tests', () {
    test('parses every unit label from all 31 supported languages correctly', () {
      final parser = TimeExpressionParser();
      final languages =
          AppLanguage.values.where((l) => l != AppLanguage.system);

      for (final lang in languages) {
        final strings = AppStrings.get(lang);
        final units = strings.units;

        final unitExpectations = <String, DurationUnit>{
          units.year: DurationUnit.year,
          units.month: DurationUnit.month,
          units.week: DurationUnit.week,
          units.day: DurationUnit.day,
          units.hour: DurationUnit.hour,
          units.minute: DurationUnit.minute,
          units.second: DurationUnit.second,
        };

        for (final entry in unitExpectations.entries) {
          final label = entry.key;
          final expectedUnit = entry.value;

          final state = parser.evaluate('1$label');
          expect(
            state.isValid,
            isTrue,
            reason: 'Language ${lang.code} failed to parse unit "$label"',
          );
          expect(
            state.value?.durationSeconds,
            expectedUnit.seconds,
            reason:
                'Language ${lang.code} unit "$label" parsed to wrong duration',
          );
        }
      }
    });
  });

  group('Multilingual commitCalculation and history preservation', () {
    test('preserves language units upon commitCalculation and in history storage', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = HistoryStorage();
      await storage.load();
      final settings = AppSettings();
      await settings.load();
      await settings.setLanguage(AppLanguage.english);

      final controller =
          CalculatorController(storage: storage, settings: settings);

      controller.appendText('1');
      controller.appendUnit('h');
      controller.appendText('+');
      controller.appendText('30');
      controller.appendUnit('m');

      await controller.commitCalculation();

      // 英語の単位「1hr 30min」として確定され、日本語「1時間30分」に縮退しないこと
      expect(controller.state.expression, '1hr 30min');
      expect(controller.state.history.length, 1);
      expect(controller.state.history.first.resultText, '1hr 30min');

      // 継続計算で単位が保持されること
      controller.appendText('+');
      controller.appendText('15');
      controller.appendUnit('m');

      await controller.commitCalculation();
      expect(controller.state.expression, '1hr 45min');
      expect(controller.state.history.length, 2);
      expect(controller.state.history.first.resultText, '1hr 45min');
    });

    test('issues single notifyListeners call on commitCalculation', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = HistoryStorage();
      await storage.load();
      final settings = AppSettings();
      await settings.load();

      final controller =
          CalculatorController(storage: storage, settings: settings);

      controller.appendText('10');
      controller.appendUnit('分');
      controller.appendText('+');
      controller.appendText('5');
      controller.appendUnit('分');

      var notifyCount = 0;
      controller.addListener(() {
        notifyCount++;
      });

      await controller.commitCalculation();
      expect(notifyCount, 1);
    });
  });

  group('AppStrings semanticsKeypad localization tests', () {
    test('returns localized semantics labels for Japanese, English, and Chinese', () {
      final ja = AppStrings.get(AppLanguage.japanese);
      expect(ja.semanticsKeypad('backspace'), '1文字削除');
      expect(ja.semanticsKeypad('='), '計算実行');
      expect(ja.semanticsKeypad('÷'), '割る');

      final en = AppStrings.get(AppLanguage.english);
      expect(en.semanticsKeypad('backspace'), 'Backspace');
      expect(en.semanticsKeypad('='), 'Calculate');
      expect(en.semanticsKeypad('÷'), 'Divide');

      final zh = AppStrings.get(AppLanguage.simplifiedChinese);
      expect(zh.semanticsKeypad('backspace'), '删除单个字符');
      expect(zh.semanticsKeypad('='), '计算');
      expect(zh.semanticsKeypad('÷'), '除以');
    });

    testWidgets('HistoryScreen includes summary header on copy even when total seconds is zero', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = HistoryStorage();
      await storage.load();
      await storage.upsert(CalculationRecord(
        id: '1',
        expression: '1時間-1時間',
        resultText: '0秒',
        seconds: 0.0,
        createdAt: DateTime.now(),
      ));

      final settings = AppSettings();
      await settings.load();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: HistoryScreen(storage: storage, settings: settings),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0秒'), findsWidgets);

      final copyButton = find.byIcon(Icons.copy_all_outlined);
      expect(copyButton, findsOneWidget);
      await tester.tap(copyButton);
      await tester.pump();

      expect(find.text('全履歴をクリップボードにコピーしました'), findsOneWidget);
    });
  });

  group('Colon handling and unit prevention tests', () {
    late CalculatorController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final storage = HistoryStorage();
      await storage.load();
      final settings = AppSettings();
      await settings.load();
      controller = CalculatorController(storage: storage, settings: settings);
    });

    test('prevents appending time units after colon-formatted time literal', () {
      controller.appendText('10');
      controller.appendText(':');
      controller.appendText('30');
      expect(controller.state.expression, '10:30');

      // 10:30の直後に単位「分」を追加しても無視されること
      controller.appendUnit('分');
      expect(controller.state.expression, '10:30');

      controller.appendUnit('時間');
      expect(controller.state.expression, '10:30');
    });

    test('replaces trailing colon when operator is entered', () {
      controller.appendText('10');
      controller.appendText(':');
      expect(controller.state.expression, '10:');

      // 10: の直後に + を押すと : が置換されて 10+ になること
      controller.appendText('+');
      expect(controller.state.expression, '10+');

      controller.appendText('5');
      expect(controller.state.expression, '10+5');
    });

    test('blocks closing parenthesis when trailing character is colon', () {
      controller.appendText('(');
      controller.appendText('10');
      controller.appendText(':');
      expect(controller.state.expression, '(10:');

      controller.appendText(')');
      expect(controller.state.expression, '(10:');
    });
  });

  group('ExpressionSpanFormatter percent operator styling', () {
    test('styles percent % character with syntaxOperator color', () {
      final theme = ThemeData.dark();
      final palette = AppThemePalette.ofTheme(theme);
      final span = ExpressionSpanFormatter.build('50%', theme, 16);

      expect(span.children, isNotNull);
      final percentSpan = span.children!.whereType<TextSpan>().firstWhere(
            (s) => s.text == '%',
          );
      expect(percentSpan.style?.color, palette.syntaxOperator);
    });
  });

  group('formatRelativeDate safe fallback tests', () {
    test('formats without throwing LocaleDataException even with uninitialized locale', () {
      final now = DateTime.now();
      final past = now.subtract(const Duration(days: 400));
      final strings = AppStrings.get(AppLanguage.japanese);

      expect(
        () => TimeFormatter.formatRelativeDate(past, strings, 'uninitialized_locale'),
        returnsNormally,
      );
    });
  });

  group('HistoryStorage auto-load on write tests', () {
    test('upsert automatically loads existing records if load was not explicitly called', () async {
      SharedPreferences.setMockInitialValues({
        'records': [
          '{"id":"existing_1","expression":"10+5","resultText":"15","createdAt":"2026-01-01T00:00:00.000"}'
        ]
      });

      final storage = HistoryStorage();
      expect(storage.isLoaded, isFalse);

      await storage.upsert(CalculationRecord(
        id: 'new_2',
        expression: '20+5',
        resultText: '25',
        createdAt: DateTime.now(),
      ));

      expect(storage.isLoaded, isTrue);
      expect(storage.records.length, 2);
      expect(storage.records.any((r) => r.id == 'existing_1'), isTrue);
      expect(storage.records.any((r) => r.id == 'new_2'), isTrue);
    });
  });
}
