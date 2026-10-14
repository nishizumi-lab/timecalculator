enum ParserErrorCode {
  unexpectedEnd,
  invalidNumber,
  missingMinuteAfterColon,
  invalidMinuteNumber,
  missingSecondAfterColon,
  invalidSecondNumber,
  unsupportedUnit,
  missingClosingParen,
  invalidExpressionStart,
  multiplyDurationsNotSupported,
  divisionByZero,
  unsupportedOperator,
  unsupportedChar,
  generalError,
}

class ParserException implements Exception {
  const ParserException(this.code, [this.details]);

  final ParserErrorCode code;
  final String? details;

  @override
  String toString() =>
      details != null ? 'ParserException($code: $details)' : 'ParserException($code)';
}
