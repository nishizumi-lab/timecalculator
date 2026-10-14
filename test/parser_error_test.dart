import 'package:flutter_test/flutter_test.dart';
import 'package:timecalculator/l10n/app_strings.dart';
import 'package:timecalculator/parser/parser_error.dart';
import 'package:timecalculator/parser/time_expression_parser.dart';

void main() {
  final parser = TimeExpressionParser();

  group('Parser Error Code Generation Tests', () {
    test('division by zero produces divisionByZero error code', () {
      final res = parser.evaluate('10 ÷ 0');
      expect(res.isValid, isFalse);
      expect(res.errorCode, ParserErrorCode.divisionByZero);
    });

    test('missing minute after colon produces missingMinuteAfterColon', () {
      final res = parser.evaluate('9:');
      expect(res.isValid, isFalse);
      // '9:' -> tokenizer produces [9, :] -> parsePrimary checks colon and fails
      expect(res.errorCode, ParserErrorCode.missingMinuteAfterColon);
    });

    test('missing second after second colon produces missingSecondAfterColon', () {
      final res = parser.evaluate('9:30:');
      expect(res.isValid, isFalse);
      expect(res.errorCode, ParserErrorCode.missingSecondAfterColon);
    });

    test('multiplying two durations produces multiplyDurationsNotSupported', () {
      final res = parser.evaluate('2時間 × 3時間');
      expect(res.isValid, isFalse);
      expect(res.errorCode, ParserErrorCode.multiplyDurationsNotSupported);
    });

    test('unclosed parenthesis produces missingClosingParen', () {
      final res = parser.evaluate('(2時間+30分');
      expect(res.isValid, isFalse);
      expect(res.errorCode, ParserErrorCode.missingClosingParen);
    });

    test('unsupported character produces unsupportedChar', () {
      final res = parser.evaluate('2時間 @ 3');
      expect(res.isValid, isFalse);
      expect(res.errorCode, ParserErrorCode.unsupportedChar);
      expect(res.errorDetails, '@');
    });
  });

  group('Multilingual Error Message Formatting Tests', () {
    final ja = AppStrings.get(AppLanguage.japanese);
    final en = AppStrings.get(AppLanguage.english);

    test('division by zero localization', () {
      expect(
        ja.formatParserError(ParserErrorCode.divisionByZero),
        '0では割れません',
      );
      expect(
        en.formatParserError(ParserErrorCode.divisionByZero),
        'Cannot divide by zero',
      );
    });

    test('multiply durations localization', () {
      expect(
        ja.formatParserError(ParserErrorCode.multiplyDurationsNotSupported),
        '時間どうしの掛け算には対応していません',
      );
      expect(
        en.formatParserError(ParserErrorCode.multiplyDurationsNotSupported),
        'Multiplying two durations is not supported',
      );
    });

    test('unsupported character localization with parameter', () {
      expect(
        ja.formatParserError(ParserErrorCode.unsupportedChar, '#'),
        '未対応の文字です: #',
      );
      expect(
        en.formatParserError(ParserErrorCode.unsupportedChar, '#'),
        'Unsupported character: #',
      );
    });

    test('EvaluationState formatErrorMessage delegates to AppStrings', () {
      final res = parser.evaluate('10 ÷ 0');
      expect(res.formatErrorMessage(ja), '0では割れません');
      expect(res.formatErrorMessage(en), 'Cannot divide by zero');

      final zh = AppStrings.get(AppLanguage.simplifiedChinese);
      expect(res.formatErrorMessage(zh), '不能除以0');

      final ko = AppStrings.get(AppLanguage.korean);
      expect(res.formatErrorMessage(ko), '0으로 나눌 수 없습니다');

      final es = AppStrings.get(AppLanguage.spanish);
      expect(res.formatErrorMessage(es), 'No se puede dividir por cero');
    });
  });
}
