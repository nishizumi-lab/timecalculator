import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timecalculator/main.dart';

void main() {
  testWidgets('Equal button replaces expression and enables continuation or new calculation', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(TimeCalculatorApp(storage: HistoryStorage()));

    // 1. "1日+1日+2日" を入力
    await tester.tap(find.text('1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('日'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('日'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('日'));
    await tester.pumpAndSettle();

    // 2. "=" をタップ
    await tester.tap(find.text('='));
    await tester.pumpAndSettle();

    // 入力欄が "4日" に置き換わっていることを検証
    expect(
      tester.allWidgets.whereType<Text>().any((w) => w.data == '4日'),
      isTrue,
    );

    // 3. 続けて "+" と "5時間" を入力（連続計算）
    await tester.tap(find.text('+'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('時間'));
    await tester.pumpAndSettle();

    // 4. 再度 "=" をタップ
    await tester.tap(find.text('='));
    await tester.pumpAndSettle();

    // 入力欄が "4日5時間" に置き換わっていることを検証
    expect(
      tester.allWidgets.whereType<Text>().any((w) => w.data == '4日5時間'),
      isTrue,
    );

    // 5. 確定後に数字 "3" を入力（新規計算開始）
    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();

    // 画面上に "3" が表示されていることを検証
    expect(
      tester.allWidgets.whereType<Text>().any((w) => w.data == '3'),
      isTrue,
    );
  });
}
