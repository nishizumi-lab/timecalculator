import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timecalculator/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('HistoryStorage & CalculationRecord Tests', () {
    test('generateId produces unique ids', () {
      final id1 = CalculationRecord.generateId();
      final id2 = CalculationRecord.generateId();
      expect(id1, isNotEmpty);
      expect(id2, isNotEmpty);
      expect(id1 != id2, isTrue);
    });

    test('CalculationRecord serialization and deserialization', () {
      final now = DateTime.now();
      final record = CalculationRecord(
        id: 'test_id',
        expression: '1時間 + 30分',
        resultText: '1時間30分',
        createdAt: now,
        label: 'テスト作業',
        seconds: 5400,
        scalar: null,
      );

      final json = record.toJson();
      final decoded = CalculationRecord.fromJson(json);

      expect(decoded.id, 'test_id');
      expect(decoded.expression, '1時間 + 30分');
      expect(decoded.resultText, '1時間30分');
      expect(decoded.label, 'テスト作業');
      expect(decoded.seconds, 5400);
      expect(decoded.scalar, isNull);
    });

    test('HistoryStorage CRUD operations', () async {
      final storage = HistoryStorage();
      await storage.load();
      expect(storage.records, isEmpty);

      final record1 = CalculationRecord(
        id: '1',
        expression: '1時間 + 1時間',
        resultText: '2時間',
        createdAt: DateTime.now(),
        seconds: 7200,
      );
      await storage.upsert(record1);
      expect(storage.records.length, 1);
      expect(storage.records.first.id, '1');

      final record2 = CalculationRecord(
        id: '2',
        expression: '2時間 + 2時間',
        resultText: '4時間',
        createdAt: DateTime.now().add(const Duration(seconds: 1)),
        seconds: 14400,
      );
      await storage.upsert(record2);
      expect(storage.records.length, 2);
      expect(storage.records.first.id, '2'); // sorted by createdAt desc

      // Delete record1
      await storage.delete('1');
      expect(storage.records.length, 1);
      expect(storage.records.first.id, '2');

      // Clear all
      await storage.clearAll();
      expect(storage.records, isEmpty);
    });
  });

  group('AppSettings Tests', () {
    test('Default settings and updating language & vibration & theme', () async {
      final settings = AppSettings();
      await settings.load();

      expect(settings.vibrationEnabled, isTrue);
      expect(settings.language, AppLanguage.japanese);
      expect(settings.themeType, AppThemeType.classicDark);
      expect(settings.palette.themeType, AppThemeType.classicDark);

      var notified = 0;
      settings.addListener(() => notified++);

      await settings.setVibrationEnabled(false);
      expect(settings.vibrationEnabled, isFalse);
      expect(notified, 1);

      await settings.setLanguage(AppLanguage.english);
      expect(settings.language, AppLanguage.english);
      expect(notified, 2);

      await settings.setThemeType(AppThemeType.midnight);
      expect(settings.themeType, AppThemeType.midnight);
      expect(settings.palette.themeType, AppThemeType.midnight);
      expect(notified, 3);

      // 新たなインスタンスでloadして永続化を確認
      final settings2 = AppSettings();
      await settings2.load();
      expect(settings2.vibrationEnabled, isFalse);
      expect(settings2.language, AppLanguage.english);
      expect(settings2.themeType, AppThemeType.midnight);
    });
  });

  group('TimeFormatter Comprehensive Tests', () {
    test('formatDuration 0 seconds', () {
      expect(TimeFormatter.formatDuration(0), '0秒');
    });

    test('formatDuration complex days, hours, minutes, seconds', () {
      final totalSec = (2 * 86400) + (3 * 3600) + (4 * 60) + 5.0;
      expect(TimeFormatter.formatDuration(totalSec), '2日3時間4分5秒');
    });

    test('formatDuration negative seconds', () {
      final res = TimeFormatter.formatDuration(-3660);
      expect(res, '-1時間1分');
    });

    test('formatDuration with fractional seconds', () {
      final res = TimeFormatter.formatDuration(1.5);
      expect(res, '1.5秒');
    });

    test('formatNumberWithCommas formats correctly', () {
      expect(TimeFormatter.formatNumberWithCommas(1234567), '1,234,567');
      expect(TimeFormatter.formatNumberWithCommas(1234.56), '1,234.56');
    });

    test('formatSummaryConversions branches', () {
      // 0 seconds
      expect(TimeFormatter.formatSummaryConversions(0), '0分 / 0秒');

      // >= 1 hour
      final hourSummary = TimeFormatter.formatSummaryConversions(3600 + 1800);
      expect(hourSummary, contains('1.5時間'));
      expect(hourSummary, contains('90分'));
      expect(hourSummary, contains('5,400秒'));

      // >= 1 min and < 1 hour
      final minSummary = TimeFormatter.formatSummaryConversions(90);
      expect(minSummary, contains('1.5分'));
      expect(minSummary, contains('90秒'));
      expect(minSummary, contains('0.03時間'));

      // < 1 min
      final secSummary = TimeFormatter.formatSummaryConversions(30);
      expect(secSummary, '30秒 / 0.5分');

      // Negative duration
      final negSummary = TimeFormatter.formatSummaryConversions(-3600);
      expect(negSummary.startsWith('-'), isTrue);
    });

    test('normalizeExpressionUnits auto completion', () {
      expect(TimeFormatter.normalizeExpressionUnits('1+2時間'), '1時間+2時間');
      expect(TimeFormatter.normalizeExpressionUnits('3分+30'), '3分+30分');
    });

    test('formatRelativeDate today, yesterday, and formatted date', () {
      final now = DateTime.now();
      final todayStr = TimeFormatter.formatRelativeDate(now);
      expect(todayStr, contains('今日'));

      final yesterday = now.subtract(const Duration(days: 1));
      final yesterdayStr = TimeFormatter.formatRelativeDate(yesterday);
      expect(yesterdayStr, contains('昨日'));

      final pastYear = DateTime(2020, 1, 1, 12, 0);
      final pastStr = TimeFormatter.formatRelativeDate(pastYear);
      expect(pastStr, '2020/01/01 12:00');
    });
  });
}
