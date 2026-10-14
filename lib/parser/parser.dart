import 'dart:math' as math;
import '../models/duration_unit.dart';
import '../models/expression_value.dart';
import 'parser_error.dart';
import 'time_expression_parser.dart';
import 'tokenizer.dart';

class Parser {
  Parser(this.tokens);

  final List<Token> tokens;
  int current = 0;

  bool get isAtEnd => current >= tokens.length;

  ExpressionValue parseExpression() {
    var value = parseTerm();
    while (_match([TokenType.plus, TokenType.minus])) {
      final operator = _previous();
      final right = parseTerm();
      value = _applyBinary(operator.type, value, right);
    }
    return value;
  }

  ExpressionValue parseTerm() {
    var value = parseUnary();
    while (_match([TokenType.multiply, TokenType.divide])) {
      final operator = _previous();
      final right = parseUnary();
      value = _applyBinary(operator.type, value, right);
    }
    return value;
  }

  ExpressionValue parseUnary() {
    if (_match([TokenType.plus])) {
      return parseUnary();
    }
    if (_match([TokenType.minus])) {
      final value = parseUnary();
      return switch (value.kind) {
        ValueKind.duration => ExpressionValue.duration(
          -(value.durationSeconds!),
          unitSeconds: value.unitSeconds,
        ),
        ValueKind.scalar => ExpressionValue.scalar(-(value.scalar!)),
      };
    }
    return parsePostfix();
  }

  ExpressionValue parsePostfix() {
    var value = parsePrimary();
    while (_match([TokenType.percent])) {
      value = switch (value.kind) {
        ValueKind.duration => ExpressionValue.duration(
          value.durationSeconds! / 100,
          unitSeconds: value.unitSeconds,
        ),
        ValueKind.scalar => ExpressionValue.scalar(value.scalar! / 100),
      };
    }
    return value;
  }

  ExpressionValue parsePrimary() {
    if (_match([TokenType.number])) {
      final number = double.tryParse(_previous().lexeme);
      if (number == null) {
        throw const ParserException(ParserErrorCode.invalidNumber);
      }
      if (_match([TokenType.colon])) {
        if (!_match([TokenType.number])) {
          throw const ParserException(ParserErrorCode.missingMinuteAfterColon);
        }
        final minutes = double.tryParse(_previous().lexeme);
        if (minutes == null) {
          throw const ParserException(ParserErrorCode.invalidMinuteNumber);
        }
        var totalSec = (number * 3600) + (minutes * 60);
        var unitSec = 60.0;
        if (_match([TokenType.colon])) {
          if (!_match([TokenType.number])) {
            throw const ParserException(ParserErrorCode.missingSecondAfterColon);
          }
          final seconds = double.tryParse(_previous().lexeme);
          if (seconds == null) {
            throw const ParserException(ParserErrorCode.invalidSecondNumber);
          }
          totalSec += seconds;
          unitSec = 1.0;
        }
        return ExpressionValue.duration(totalSec, unitSeconds: unitSec);
      }
      if (_match([TokenType.unit])) {
        final unit = TimeExpressionParser.getUnit(_previous().lexeme);
        if (unit == null) {
          throw const ParserException(ParserErrorCode.unsupportedUnit);
        }
        var totalSeconds = number * unit.seconds;
        var lastUnitSeconds = unit.seconds;
        while (current + 1 < tokens.length &&
            tokens[current].type == TokenType.number &&
            tokens[current + 1].type == TokenType.unit) {
          _match([TokenType.number]);
          final nextNum = double.tryParse(_previous().lexeme);
          if (nextNum == null) {
            throw const ParserException(ParserErrorCode.invalidNumber);
          }
          _match([TokenType.unit]);
          final nextUnit = TimeExpressionParser.getUnit(_previous().lexeme);
          if (nextUnit == null) {
            throw const ParserException(ParserErrorCode.unsupportedUnit);
          }
          totalSeconds += nextNum * nextUnit.seconds;
          lastUnitSeconds = nextUnit.seconds;
        }
        return ExpressionValue.duration(totalSeconds, unitSeconds: lastUnitSeconds);
      }
      return ExpressionValue.scalar(number);
    }
    if (_match([TokenType.lParen])) {
      final value = parseExpression();
      _consume(TokenType.rParen, ParserErrorCode.missingClosingParen);
      return value;
    }
    throw const ParserException(ParserErrorCode.invalidExpressionStart);
  }

  static double? _resolveUnitSeconds(double? u1, double? u2) {
    if (u1 == null) return u2;
    if (u2 == null) return u1;
    return math.min(u1, u2);
  }

  ExpressionValue _applyBinary(
    TokenType type,
    ExpressionValue left,
    ExpressionValue right,
  ) {
    switch (type) {
      case TokenType.plus:
        if (left.kind == ValueKind.duration && right.kind == ValueKind.duration) {
          return ExpressionValue.duration(
            left.durationSeconds! + right.durationSeconds!,
            unitSeconds: _resolveUnitSeconds(left.unitSeconds, right.unitSeconds),
          );
        }
        if (left.kind == ValueKind.duration && right.kind == ValueKind.scalar) {
          final unitSec = left.unitSeconds ?? DurationUnit.second.seconds;
          return ExpressionValue.duration(
            left.durationSeconds! + (right.scalar! * unitSec),
            unitSeconds: unitSec,
          );
        }
        if (left.kind == ValueKind.scalar && right.kind == ValueKind.duration) {
          final unitSec = right.unitSeconds ?? DurationUnit.second.seconds;
          return ExpressionValue.duration(
            (left.scalar! * unitSec) + right.durationSeconds!,
            unitSeconds: unitSec,
          );
        }
        return ExpressionValue.scalar(left.scalar! + right.scalar!);

      case TokenType.minus:
        if (left.kind == ValueKind.duration && right.kind == ValueKind.duration) {
          return ExpressionValue.duration(
            left.durationSeconds! - right.durationSeconds!,
            unitSeconds: _resolveUnitSeconds(left.unitSeconds, right.unitSeconds),
          );
        }
        if (left.kind == ValueKind.duration && right.kind == ValueKind.scalar) {
          final unitSec = left.unitSeconds ?? DurationUnit.second.seconds;
          return ExpressionValue.duration(
            left.durationSeconds! - (right.scalar! * unitSec),
            unitSeconds: unitSec,
          );
        }
        if (left.kind == ValueKind.scalar && right.kind == ValueKind.duration) {
          final unitSec = right.unitSeconds ?? DurationUnit.second.seconds;
          return ExpressionValue.duration(
            (left.scalar! * unitSec) - right.durationSeconds!,
            unitSeconds: unitSec,
          );
        }
        return ExpressionValue.scalar(left.scalar! - right.scalar!);

      case TokenType.multiply:
        if (left.kind == ValueKind.duration &&
            right.kind == ValueKind.duration) {
          throw const ParserException(
            ParserErrorCode.multiplyDurationsNotSupported,
          );
        }
        if (left.kind == ValueKind.duration) {
          return ExpressionValue.duration(
            left.durationSeconds! * right.scalar!,
            unitSeconds: left.unitSeconds,
          );
        }
        if (right.kind == ValueKind.duration) {
          return ExpressionValue.duration(
            left.scalar! * right.durationSeconds!,
            unitSeconds: right.unitSeconds,
          );
        }
        return ExpressionValue.scalar(left.scalar! * right.scalar!);

      case TokenType.divide:
        final divisor = right.kind == ValueKind.duration
            ? right.durationSeconds!
            : right.scalar!;
        if (divisor == 0) {
          throw const ParserException(ParserErrorCode.divisionByZero);
        }
        if (left.kind == ValueKind.duration &&
            right.kind == ValueKind.duration) {
          return ExpressionValue.scalar(left.durationSeconds! / divisor);
        }
        if (left.kind == ValueKind.duration) {
          return ExpressionValue.duration(
            left.durationSeconds! / divisor,
            unitSeconds: left.unitSeconds,
          );
        }
        if (right.kind == ValueKind.duration) {
          final unitSec = right.unitSeconds ?? DurationUnit.second.seconds;
          return ExpressionValue.scalar((left.scalar! * unitSec) / divisor);
        }
        return ExpressionValue.scalar(left.scalar! / divisor);
      default:
        throw const ParserException(ParserErrorCode.unsupportedOperator);
    }
  }

  bool _match(List<TokenType> types) {
    for (final type in types) {
      if (_check(type)) {
        current++;
        return true;
      }
    }
    return false;
  }

  bool _check(TokenType type) {
    if (isAtEnd) {
      return false;
    }
    return tokens[current].type == type;
  }

  Token _previous() => tokens[current - 1];

  void _consume(TokenType type, ParserErrorCode errorCode) {
    if (_check(type)) {
      current++;
      return;
    }
    throw ParserException(errorCode);
  }
}
