import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timecalculator/main.dart';

void main() {
  group('Colon Time Calculations', () {
    final parser = TimeExpressionParser();

    test('18:00 - 9:30 evaluates to 8時間30分', () {
      final res = parser.evaluate('18:00 - 9:30');
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, equals(8.5 * 3600));
      expect(res.displayText, equals('8時間30分'));
    });

    test('9:30 + 1:45 evaluates to 11時間15分', () {
      final res = parser.evaluate('9:30 + 1:45');
      expect(res.isValid, isTrue);
      expect(res.value?.durationSeconds, equals(11.25 * 3600));
      expect(res.displayText, equals('11時間15分'));
    });

    test('1:30:15 + 0:15:30 evaluates to 1時間45分45秒', () {
      final res = parser.evaluate('1:30:15 + 0:15:30');
      expect(res.isValid, isTrue);
      expect(res.displayText, equals('1時間45分45秒'));
    });

    test('Mixing colon time with duration: 9:30 + 45分 = 10時間15分', () {
      final res = parser.evaluate('9:30 + 45分');
      expect(res.isValid, isTrue);
      expect(res.displayText, equals('10時間15分'));
    });
  });

  testWidgets('Keypad Colon Input and Calculation Widget Test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(TimeCalculatorApp(storage: HistoryStorage()));

    // 18:00 - 9:30 を入力
    await tester.tap(find.text('1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('8'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(':'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('00'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('−'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('9'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(':'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('0'));
    await tester.pumpAndSettle();

    // プレビューが '8時間30分'
    expect(
      tester.allWidgets.whereType<Text>().any((w) => w.data == '8時間30分'),
      isTrue,
    );

    // '=' をタップして確定
    await tester.tap(find.text('='));
    await tester.pumpAndSettle();

    expect(
      tester.allWidgets.whereType<Text>().any((w) => w.data == '8時間30分'),
      isTrue,
    );
  });
}
