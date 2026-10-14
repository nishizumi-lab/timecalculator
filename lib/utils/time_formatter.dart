import 'package:intl/intl.dart';
import '../l10n/app_strings.dart';
import '../models/duration_unit.dart';
import '../parser/tokenizer.dart';

class TimeFormatter {
  static const _defaultUnits = UnitLabels(
    year: '年',
    month: 'ヶ月',
    week: '週間',
    day: '日',
    hour: '時間',
    minute: '分',
    second: '秒',
  );

  static String formatDuration(double seconds, [UnitLabels? units]) {
    if (!seconds.isFinite) return '...';
    final u = units ?? _defaultUnits;
    final negative = seconds < 0;
    var remaining = seconds.abs();
    final days = (remaining / DurationUnit.day.seconds).floor();
    remaining -= days * DurationUnit.day.seconds;
    final hours = (remaining / DurationUnit.hour.seconds).floor();
    remaining -= hours * DurationUnit.hour.seconds;
    final minutes = (remaining / DurationUnit.minute.seconds).floor();
    remaining -= minutes * DurationUnit.minute.seconds;
    final wholeSeconds = remaining.floor();
    final fractional = remaining - wholeSeconds;

    final parts = <String>[];
    if (days > 0) {
      parts.add('$days${u.day}');
    }
    if (hours > 0) {
      parts.add('$hours${u.hour}');
    }
    if (minutes > 0) {
      parts.add('$minutes${u.minute}');
    }
    if (wholeSeconds > 0 || fractional > 0.000001 || parts.isEmpty) {
      if (fractional > 0.000001) {
        parts.add('${formatDecimal(wholeSeconds + fractional)}${u.second}');
      } else {
        parts.add('$wholeSeconds${u.second}');
      }
    }
    return '${negative ? '-' : ''}${parts.join(u.separator)}';
  }

  static String formatNumberWithCommas(num value) {
    if (!value.isFinite) return value.toString();
    if (value is int || value == value.roundToDouble()) {
      return NumberFormat('#,##0').format(value);
    }
    return NumberFormat('#,##0.###').format(value);
  }

  static String formatDecimal(double value) {
    if (!value.isFinite) return value.toString();
    final text = value.toStringAsFixed(9);
    if (text.contains('e') || text.contains('E')) return text;
    return text.contains('.')
        ? text.replaceFirst(RegExp(r'\.?0+$'), '')
        : text;
  }

  static String formatSummaryConversions(double seconds, [UnitLabels? units]) {
    if (!seconds.isFinite) return '...';
    final u = units ?? _defaultUnits;
    final absSec = seconds.abs();
    final negative = seconds < 0 ? '-' : '';

    if (absSec == 0) {
      return '0${u.minute} / 0${u.second}';
    }

    final totalHours = absSec / 3600.0;
    final totalMinutes = absSec / 60.0;
    final totalSeconds = absSec;

    // 1時間以上の場合: ( 8.05時間 / 483分 / 28,980秒 )
    if (absSec >= 3600) {
      final hoursStr = (totalHours == totalHours.roundToDouble())
          ? '${formatNumberWithCommas(totalHours.toInt())}${u.hour}'
          : '${NumberFormat('#,##0.##').format(totalHours)}${u.hour}';

      final minStr = (totalMinutes == totalMinutes.roundToDouble())
          ? '${formatNumberWithCommas(totalMinutes.toInt())}${u.minute}'
          : '${NumberFormat('#,##0.##').format(totalMinutes)}${u.minute}';

      final secStr = '${formatNumberWithCommas(totalSeconds.round())}${u.second}';

      return '$negative$hoursStr / $minStr / $secStr';
    }

    // 1分以上1時間未満の場合: ( 45.5分 / 2,730秒 / 0.76時間 )
    if (absSec >= 60) {
      final minStr = (totalMinutes == totalMinutes.roundToDouble())
          ? '${formatNumberWithCommas(totalMinutes.toInt())}${u.minute}'
          : '${NumberFormat('#,##0.##').format(totalMinutes)}${u.minute}';

      final secStr = '${formatNumberWithCommas(totalSeconds.round())}${u.second}';
      final hoursStr = '${NumberFormat('#,##0.##').format(totalHours)}${u.hour}';

      return '$negative$minStr / $secStr / $hoursStr';
    }

    // 1分未満の場合: ( 45秒 / 0.75分 )
    final secStr = '${formatNumberWithCommas(totalSeconds)}${u.second}';
    final minStr = '${NumberFormat('#,##0.##').format(totalMinutes)}${u.minute}';
    return '$negative$secStr / $minStr';
  }

  static String normalizeExpressionUnits(String expr) {
    try {
      final normalized = expr.replaceAll(' ', '');
      final tokens = Tokenizer(normalized).tokenize();
      if (tokens.isEmpty) return expr;

      final buffer = StringBuffer();
      for (var i = 0; i < tokens.length; i++) {
        final t = tokens[i];
        buffer.write(t.lexeme);
        if (t.type == TokenType.number) {
          final hasUnitNext =
              (i + 1 < tokens.length && tokens[i + 1].type == TokenType.unit);
          final isMulOrDivOperand = (i > 0 &&
                  (tokens[i - 1].type == TokenType.multiply ||
                      tokens[i - 1].type == TokenType.divide ||
                      tokens[i - 1].type == TokenType.colon ||
                      tokens[i - 1].type == TokenType.percent)) ||
              (i + 1 < tokens.length &&
                  (tokens[i + 1].type == TokenType.multiply ||
                      tokens[i + 1].type == TokenType.divide ||
                      tokens[i + 1].type == TokenType.colon ||
                      tokens[i + 1].type == TokenType.percent));
          if (!hasUnitNext && !isMulOrDivOperand) {
            String? inferredUnit;
            for (var j = i + 1; j < tokens.length; j++) {
              final type = tokens[j].type;
              if (type == TokenType.multiply ||
                  type == TokenType.divide ||
                  type == TokenType.colon ||
                  type == TokenType.percent ||
                  type == TokenType.lParen ||
                  type == TokenType.rParen) {
                break;
              }
              if (type == TokenType.unit) {
                inferredUnit = tokens[j].lexeme;
                break;
              }
            }
            if (inferredUnit == null) {
              for (var j = i - 1; j >= 0; j--) {
                final type = tokens[j].type;
                if (type == TokenType.multiply ||
                    type == TokenType.divide ||
                    type == TokenType.colon ||
                    type == TokenType.percent ||
                    type == TokenType.lParen ||
                    type == TokenType.rParen) {
                  break;
                }
                if (type == TokenType.unit) {
                  inferredUnit = tokens[j].lexeme;
                  break;
                }
              }
            }
            if (inferredUnit != null) {
              buffer.write(inferredUnit);
            }
          }
        }
      }
      return buffer.toString();
    } catch (_) {
      return expr;
    }
  }

  static String formatRelativeDate(DateTime dt, [AppStrings? strings, String? locale]) {
    final s = strings ?? AppStrings.get(AppLanguage.japanese);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dt.year, dt.month, dt.day);
    final timeStr = DateFormat('HH:mm').format(dt);

    if (date == today) {
      return '${s.today} $timeStr';
    } else if (date == yesterday) {
      return '${s.yesterday} $timeStr';
    } else {
      try {
        if (dt.year == now.year) {
          return DateFormat('MMM d HH:mm', locale).format(dt);
        }
        return DateFormat('yyyy/MM/dd HH:mm', locale).format(dt);
      } catch (_) {
        return DateFormat('yyyy/MM/dd HH:mm').format(dt);
      }
    }
  }
}
