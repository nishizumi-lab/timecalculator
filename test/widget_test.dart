import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timecalculator/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HistoryStorage storage;
  late AppSettings settings;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = HistoryStorage();
    await storage.load();
    settings = AppSettings();
    await settings.load();
  });

  testWidgets('calculator screen renders keypad and unit buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      TimeCalculatorApp(storage: storage, settings: settings),
    );
    await tester.pumpAndSettle();

    expect(find.text('年'), findsOneWidget);
    expect(find.text('月'), findsOneWidget);
    expect(find.text('週'), findsOneWidget);
    expect(find.text('日'), findsOneWidget);
    expect(find.text('時間'), findsOneWidget);
    expect(find.text('分'), findsOneWidget);
    expect(find.text('秒'), findsOneWidget);
    expect(find.text('='), findsOneWidget);
  });

  testWidgets('tap numbers and calculation displays result', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      TimeCalculatorApp(storage: storage, settings: settings),
    );
    await tester.pumpAndSettle();

    // Tap 5 -> 時間 -> + -> 30 -> 分 -> =
    await tester.tap(find.widgetWithText(KeypadButton, '5'));
    await tester.pump();
    await tester.tap(find.widgetWithText(KeypadButton, '時間'));
    await tester.pump();
    await tester.tap(find.widgetWithText(KeypadButton, '+'));
    await tester.pump();
    await tester.tap(find.widgetWithText(KeypadButton, '3'));
    await tester.pump();
    await tester.tap(find.widgetWithText(KeypadButton, '0'));
    await tester.pump();
    await tester.tap(find.widgetWithText(KeypadButton, '分'));
    await tester.pump();

    expect(find.text('5時間+30分'), findsOneWidget);
    expect(find.text('5時間30分'), findsOneWidget);

    await tester.tap(find.widgetWithText(KeypadButton, '='));
    await tester.pumpAndSettle();

    // After =, result becomes the expression
    expect(find.text('5時間30分'), findsWidgets);
  });

  testWidgets('navigation to settings screen and back', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      TimeCalculatorApp(storage: storage, settings: settings),
    );
    await tester.pumpAndSettle();

    // Tap settings icon in AppBar
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('設定'), findsOneWidget);
    expect(find.text('言語'), findsOneWidget);
    expect(find.text('キー入力の振動'), findsOneWidget);

    // Navigate back
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('時間計算機'), findsOneWidget);
  });

  testWidgets('navigation to history screen and back', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      TimeCalculatorApp(storage: storage, settings: settings),
    );
    await tester.pumpAndSettle();

    // Tap history icon in AppBar
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();

    expect(find.text('履歴'), findsOneWidget);
    expect(find.text('履歴がありません'), findsOneWidget);

    // Tap close icon
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text('時間計算機'), findsOneWidget);
  });

  testWidgets('navigation to conversion screen from conversion badge', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      TimeCalculatorApp(storage: storage, settings: settings),
    );
    await tester.pumpAndSettle();

    // Input 1時間
    await tester.tap(find.widgetWithText(KeypadButton, '1'));
    await tester.pump();
    await tester.tap(find.widgetWithText(KeypadButton, '時間'));
    await tester.pumpAndSettle();

    // Tap conversion badge
    final badgeFinder = find.byType(InkWell).first;
    await tester.tap(badgeFinder);
    await tester.pumpAndSettle();

    expect(find.text('単位換算'), findsOneWidget);
    expect(find.text('3600 秒'), findsOneWidget);
    expect(find.text('60 分'), findsOneWidget);

    // Navigate back
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text('時間計算機'), findsOneWidget);
  });
}
