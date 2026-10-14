import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timecalculator/controllers/calculator_controller.dart';
import 'package:timecalculator/services/app_settings.dart';
import 'package:timecalculator/services/history_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  group('CalculatorController Basic Operations', () {
    test('initial state is empty', () {
      expect(controller.state.expression, '');
      expect(controller.state.preview, isNull);
      expect(controller.state.isEvaluated, isFalse);
      expect(controller.state.history, isEmpty);
    });

    test('appendText appends digits and calculates preview', () {
      controller.appendText('1');
      controller.appendText('2');
      expect(controller.state.expression, '12');
      expect(controller.state.preview?.isValid, isTrue);
      expect(controller.state.preview?.value?.scalar, 12);
    });

    test('appendUnit appends time unit and evaluates duration', () {
      controller.appendText('5');
      controller.appendUnit('時間');
      expect(controller.state.expression, '5時間');
      expect(controller.state.preview?.isValid, isTrue);
      expect(controller.state.preview?.value?.durationSeconds, 5 * 3600);
    });

    test('appendUnit prevents appending when last char is not a digit', () {
      controller.appendText('5');
      controller.appendText('+');
      controller.appendUnit('時間');
      expect(controller.state.expression, '5+');

      controller.clear();
      controller.appendText('5.');
      controller.appendUnit('時間');
      expect(controller.state.expression, '5.');
    });

    test('00 input handling in empty or non-empty expression', () {
      controller.appendText('00');
      expect(controller.state.expression, '0');

      controller.clear();
      controller.appendText('5');
      controller.appendText('00');
      expect(controller.state.expression, '500');
    });

    test('prevent duplicate dots in single number token', () {
      controller.appendText('3');
      controller.appendText('.');
      controller.appendText('1');
      controller.appendText('.');
      expect(controller.state.expression, '3.1');
    });

    test('dot on empty starts with 0.', () {
      controller.appendText('.');
      expect(controller.state.expression, '0.');
    });

    test('colon input limit and formatting', () {
      controller.appendText('9');
      controller.appendText(':');
      controller.appendText('30');
      expect(controller.state.expression, '9:30');
      expect(controller.state.preview?.isValid, isTrue);
      expect(controller.state.preview?.value?.durationSeconds, (9 * 3600) + (30 * 60));

      // Third colon is blocked
      controller.appendText(':');
      controller.appendText('15');
      controller.appendText(':');
      expect(controller.state.expression, '9:30:15');
    });

    test('operator replacement when entered consecutively', () {
      controller.appendText('5');
      controller.appendText('+');
      controller.appendText('×');
      expect(controller.state.expression, '5×');
    });

    test('negative number as leading or after parenthesis', () {
      controller.appendText('-');
      controller.appendText('5');
      expect(controller.state.expression, '-5');
      expect(controller.state.preview?.value?.scalar, -5);

      controller.clear();
      controller.appendText('(');
      controller.appendText('-');
      controller.appendText('3');
      controller.appendText(')');
      expect(controller.state.expression, '(-3)');
      expect(controller.state.preview?.value?.scalar, -3);
    });

    test('backspace removes last character', () {
      controller.appendText('123');
      controller.backspace();
      expect(controller.state.expression, '12');
      controller.backspace();
      expect(controller.state.expression, '1');
      controller.backspace();
      expect(controller.state.expression, '');
      controller.backspace(); // No error on empty
      expect(controller.state.expression, '');
    });

    test('clear resets expression, preview, and state', () {
      controller.appendText('10時間+30分');
      expect(controller.state.expression, '10時間+30分');
      controller.clear();
      expect(controller.state.expression, '');
      expect(controller.state.preview, isNull);
      expect(controller.state.isEvaluated, isFalse);
    });
  });

  group('CalculatorController Multilingual & Smart Parenthesis', () {
    test('blocks entering digits directly after multilingual units', () {
      controller.appendText('5');
      controller.appendUnit('hours');
      expect(controller.state.expression, '5hours');
      controller.appendText('2');
      // Should remain '5hours' because entering digit right after unit is prevented
      expect(controller.state.expression, '5hours');
    });

    test('smart parenthesis logic', () {
      // 1. Empty expression -> '('
      controller.appendParenthesis();
      expect(controller.state.expression, '(');

      // 2. Open paren not closed, digit entered -> ')'
      controller.appendText('5');
      controller.appendParenthesis();
      expect(controller.state.expression, '(5)');

      // 3. Already balanced, digit/paren -> implicit multiplication '×('
      controller.appendParenthesis();
      expect(controller.state.expression, '(5)×(');
    });

    test('smart parenthesis with time unit', () {
      controller.appendParenthesis();
      controller.appendText('1');
      controller.appendUnit('時間');
      controller.appendText('+');
      controller.appendText('30');
      controller.appendUnit('分');
      controller.appendParenthesis();
      expect(controller.state.expression, '(1時間+30分)');
      expect(controller.state.preview?.value?.durationSeconds, 5400);
    });
  });

  group('CalculatorController Calculation & History Commitment', () {
    test('commitCalculation saves record and updates expression', () async {
      controller.appendText('2時間');
      controller.appendText('+');
      controller.appendText('30分');
      expect(controller.state.preview?.isValid, isTrue);

      await controller.commitCalculation();
      expect(controller.state.isEvaluated, isTrue);
      expect(controller.state.evaluatedExpression, '2時間+30分');
      expect(controller.state.expression, '2時間30分');
      expect(controller.state.history.length, 1);
      expect(controller.state.history.first.expression, '2時間+30分');
      expect(controller.state.history.first.resultText, '2時間30分');
    });

    test('entering new digit after evaluation resets expression', () async {
      controller.appendText('10+5');
      await controller.commitCalculation();
      expect(controller.state.expression, '15');

      controller.appendText('7');
      expect(controller.state.expression, '7');
      expect(controller.state.isEvaluated, isFalse);
    });

    test('entering operator after evaluation continues calculation', () async {
      controller.appendText('10+5');
      await controller.commitCalculation();
      expect(controller.state.expression, '15');

      controller.appendText('+');
      expect(controller.state.expression, '15+');
      expect(controller.state.isEvaluated, isFalse);
    });

    test('restoreExpression restores past expression', () {
      controller.restoreExpression('1日-12時間');
      expect(controller.state.expression, '1日-12時間');
      expect(controller.state.preview?.isValid, isTrue);
      expect(controller.state.preview?.value?.durationSeconds, 12 * 3600);
    });
  });
}
