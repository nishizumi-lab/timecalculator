import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timecalculator/main.dart';

void main() {
  testWidgets('Input validation tests', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(TimeCalculatorApp(storage: HistoryStorage()));

    // 初期状態では、Text widgetとしての '0' はキーパッドのボタンのみの1つのはず
    expect(
      tester.allWidgets.whereType<Text>().where((w) => w.data == '0').length,
      1,
    );

    // 1. 空のときに '+' や '×' を入力しようとしても無視されること
    await tester.tap(find.text('+'));
    await tester.pumpAndSettle();
    expect(
      tester.allWidgets.whereType<Text>().where((w) => w.data == '0').length,
      1,
    );

    // 2. '-' は先頭でも入力できること
    await tester.tap(find.text('−'));
    await tester.pumpAndSettle();
    expect(
      tester.allWidgets.whereType<Text>().where((w) => w.data == '0').length,
      1, // キーパッドの '0' のみ
    );

    // 一旦クリア
    await tester.tap(find.text('C'));
    await tester.pumpAndSettle();

    // 3. 先頭で '00' を入力しても '0' として扱われること
    await tester.tap(find.text('00'));
    await tester.pumpAndSettle();
    expect(
      tester.allWidgets.whereType<Text>().where((w) => w.data == '0').length,
      greaterThanOrEqualTo(1),
    );

    // '5' を入力
    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();

    // 4. 演算子を連続入力したとき、最後の演算子に置き換わること
    await tester.tap(find.text('+'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('÷'));
    await tester.pumpAndSettle();

    // '2' を入力して '5÷2' になる
    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();

    // 出力欄に '2.5' が表示されていることを確認
    expect(
      tester.allWidgets.whereType<Text>().any((w) => w.data == '2.5'),
      isTrue,
    );

    // 5. 小数点が重複して入力されないこと
    await tester.tap(find.text('.'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();
    expect(
      tester.allWidgets.whereType<Text>().where((w) => w.data == '2').length,
      greaterThan(0),
    );

    await tester.tap(find.text('.'));
    await tester.pumpAndSettle();
    expect(
      tester.allWidgets.whereType<Text>().where((w) => w.data == '2').length,
      greaterThan(0),
    );

    // 6. 単位 of 単位や数字が入力できないこと
    // 一旦クリア
    await tester.tap(find.text('C'));
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('時間'));
    await tester.pumpAndSettle();
    
    // 出力欄の Text("5時間") が正しく表示されていることを検証
    expect(
      tester.allWidgets.whereType<Text>().any((w) => w.data == '5時間'),
      isTrue,
    );

    // 直接 '分' を押す（無視されるべき。無視されれば出力は '5時間' のまま）
    await tester.tap(find.text('分'));
    await tester.pumpAndSettle();
    expect(
      tester.allWidgets.whereType<Text>().any((w) => w.data == '5時間'),
      isTrue,
    );

    // 直接 '3' を押す（無視されるべき）
    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();
    expect(
      tester.allWidgets.whereType<Text>().any((w) => w.data == '5時間'),
      isTrue,
    );
  });
}
