import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timecalculator/main.dart';

void main() {
  testWidgets('Smart Parenthesis ( ) Key Tests', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(TimeCalculatorApp(storage: HistoryStorage()));

    // 1. 最初は '(' が入る
    await tester.tap(find.text('( )'));
    await tester.pumpAndSettle();

    // 2. '2' '時間' '+' '30' '分' を入力
    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('時間'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('0'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('分'));
    await tester.pumpAndSettle();

    // 3. ここで '( )' を押すと自動で閉じ括弧 ')' になる
    await tester.tap(find.text('( )'));
    await tester.pumpAndSettle();

    // 4. '×' '2' を入力
    await tester.tap(find.text('×'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();

    // プレビューが '5時間' になっていることを確認
    expect(
      tester.allWidgets.whereType<Text>().any((w) => w.data == '5時間'),
      isTrue,
    );

    // 5. '=' で確定
    await tester.tap(find.text('='));
    await tester.pumpAndSettle();

    expect(
      tester.allWidgets.whereType<Text>().any((w) => w.data == '5時間'),
      isTrue,
    );
  });
}
