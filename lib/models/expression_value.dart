import '../l10n/app_strings.dart';
import '../parser/parser_error.dart';
import '../utils/time_formatter.dart';
import 'duration_unit.dart';

enum ValueKind { duration, scalar }

class ExpressionValue {
  ExpressionValue.duration(double seconds, {double? unitSeconds})
    : kind = ValueKind.duration,
      durationSeconds = seconds,
      unitSeconds = unitSeconds ?? _inferUnitSeconds(seconds),
      scalar = null;

  ExpressionValue.scalar(double value)
    : kind = ValueKind.scalar,
      scalar = value,
      durationSeconds = null,
      unitSeconds = null;

  final ValueKind kind;
  final double? durationSeconds;
  final double? scalar;
  final double? unitSeconds;

  static double _inferUnitSeconds(double seconds) {
    final absSec = seconds.abs();
    if (absSec >= DurationUnit.day.seconds) return DurationUnit.day.seconds;
    if (absSec >= DurationUnit.hour.seconds) return DurationUnit.hour.seconds;
    if (absSec >= DurationUnit.minute.seconds) return DurationUnit.minute.seconds;
    return DurationUnit.second.seconds;
  }
}

class EvaluationState {
  const EvaluationState({
    required this.isValid,
    this.value,
    this.error,
    this.errorCode,
    this.errorDetails,
  });

  final bool isValid;
  final ExpressionValue? value;
  final String? error;
  final ParserErrorCode? errorCode;
  final String? errorDetails;

  String formatDisplayText([UnitLabels? units]) {
    if (!isValid || value == null) {
      return '...';
    }
    return switch (value!.kind) {
      ValueKind.duration => value!.durationSeconds != null &&
              value!.durationSeconds!.isFinite
          ? TimeFormatter.formatDuration(value!.durationSeconds!, units)
          : '...',
      ValueKind.scalar => value!.scalar != null && value!.scalar!.isFinite
          ? TimeFormatter.formatDecimal(value!.scalar!)
          : '...',
    };
  }

  String get displayText => formatDisplayText();

  String? formatErrorMessage(AppStrings strings) {
    if (errorCode != null) {
      return strings.formatParserError(errorCode!, errorDetails);
    }
    return error;
  }
}
