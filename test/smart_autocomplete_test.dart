import 'package:flutter_test/flutter_test.dart';
import 'package:timecalculator/main.dart';

void main() {
  final parser = TimeExpressionParser();

  group('Smart Auto-completion Tests (Mixed Scalars and Durations)', () {
    test('1+1+2日 should evaluate to 4日', () {
      final state = parser.evaluate('1+1+2日');
      expect(state.isValid, isTrue);
      expect(state.displayText, '4日');
      expect(state.value?.durationSeconds, 4 * 86400.0);
    });

    test('4日 - 2 should evaluate to 2日', () {
      final state = parser.evaluate('4日-2');
      expect(state.isValid, isTrue);
      expect(state.displayText, '2日');
      expect(state.value?.durationSeconds, 2 * 86400.0);
    });

    test('10 - 2時間 should evaluate to 8時間', () {
      final state = parser.evaluate('10-2時間');
      expect(state.isValid, isTrue);
      expect(state.displayText, '8時間');
      expect(state.value?.durationSeconds, 8 * 3600.0);
    });

    test('3時間 + 30分 + 1 should evaluate to 3時間31分 (inherits 1分)', () {
      final state = parser.evaluate('3時間+30分+1');
      expect(state.isValid, isTrue);
      expect(state.displayText, '3時間31分');
    });

    test('6 ÷ 2日 should evaluate to scalar 3', () {
      final state = parser.evaluate('6÷2日');
      expect(state.isValid, isTrue);
      expect(state.displayText, '3');
      expect(state.value?.scalar, 3.0);
    });
  });
}
