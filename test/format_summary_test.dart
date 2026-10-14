import 'package:flutter_test/flutter_test.dart';
import 'package:timecalculator/main.dart';

void main() {
  group('TimeFormatter.formatSummaryConversions Tests', () {
    test('8時間3分 (28980秒) should format cleanly as (8.05時間 / 483分 / 28,980秒)', () {
      final summary = TimeFormatter.formatSummaryConversions(28980);
      expect(summary, '8.05時間 / 483分 / 28,980秒');
    });

    test('4日 (345600秒) should format cleanly as (96時間 / 5,760分 / 345,600秒)', () {
      final summary = TimeFormatter.formatSummaryConversions(345600);
      expect(summary, '96時間 / 5,760分 / 345,600秒');
    });

    test('45秒 should format as (45秒 / 0.75分)', () {
      final summary = TimeFormatter.formatSummaryConversions(45);
      expect(summary, '45秒 / 0.75分');
    });
  });

  group('TimeFormatter.normalizeExpressionUnits Tests', () {
    test('1+2分+8時間 should normalize to 1分+2分+8時間', () {
      final normalized = TimeFormatter.normalizeExpressionUnits('1+2分+8時間');
      expect(normalized, '1分+2分+8時間');
    });

    test('1+1+2日 should normalize to 1日+1日+2日', () {
      final normalized = TimeFormatter.normalizeExpressionUnits('1+1+2日');
      expect(normalized, '1日+1日+2日');
    });

    test('4日-2 should normalize to 4日-2日', () {
      final normalized = TimeFormatter.normalizeExpressionUnits('4日-2');
      expect(normalized, '4日-2日');
    });
  });
}
