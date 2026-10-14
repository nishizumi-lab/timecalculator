import 'parser_error.dart';
import 'time_expression_parser.dart';

enum TokenType {
  number,
  unit,
  plus,
  minus,
  multiply,
  divide,
  percent,
  colon,
  lParen,
  rParen,
}

class Token {
  const Token(this.type, this.lexeme);

  final TokenType type;
  final String lexeme;
}

class Tokenizer {
  Tokenizer(this.source);

  final String source;
  int index = 0;

  List<Token> tokenize() {
    final tokens = <Token>[];
    final candidates = TimeExpressionParser.unitCandidates;

    while (index < source.length) {
      final char = source[index];
      if (_isWhitespace(char)) {
        index++;
        continue;
      }
      if (_isDigit(char) || char == '.') {
        final start = index;
        while (index < source.length &&
            (_isDigit(source[index]) || source[index] == '.')) {
          index++;
        }
        if (index < source.length &&
            (source[index] == 'e' || source[index] == 'E')) {
          var nextIdx = index + 1;
          if (nextIdx < source.length &&
              (source[nextIdx] == '+' || source[nextIdx] == '-')) {
            nextIdx++;
          }
          final digitStart = nextIdx;
          while (nextIdx < source.length && _isDigit(source[nextIdx])) {
            nextIdx++;
          }
          if (nextIdx > digitStart) {
            index = nextIdx;
          }
        }
        tokens.add(Token(TokenType.number, source.substring(start, index)));
        continue;
      }
      String? unit;
      for (final candidate in candidates) {
        if (source.startsWith(candidate, index)) {
          unit = candidate;
          break;
        }
      }
      if (unit != null) {
        tokens.add(Token(TokenType.unit, unit));
        index += unit.length;
        continue;
      }
      switch (char) {
        case '+':
          tokens.add(const Token(TokenType.plus, '+'));
          break;
        case '-':
        case '−':
          tokens.add(const Token(TokenType.minus, '-'));
          break;
        case '×':
        case '*':
          tokens.add(const Token(TokenType.multiply, '×'));
          break;
        case '÷':
        case '/':
          tokens.add(const Token(TokenType.divide, '÷'));
          break;
        case '%':
          tokens.add(const Token(TokenType.percent, '%'));
          break;
        case ':':
          tokens.add(const Token(TokenType.colon, ':'));
          break;
        case '(':
          tokens.add(const Token(TokenType.lParen, '('));
          break;
        case ')':
          tokens.add(const Token(TokenType.rParen, ')'));
          break;
        default:
          throw ParserException(ParserErrorCode.unsupportedChar, char);
      }
      index++;
    }
    return tokens;
  }

  bool _isDigit(String value) =>
      value.codeUnitAt(0) >= 48 && value.codeUnitAt(0) <= 57;

  bool _isWhitespace(String value) =>
      value == ' ' ||
      value == '\t' ||
      value == '\n' ||
      value == '\r' ||
      value == '\u3000';
}
