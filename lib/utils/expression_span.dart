import 'package:flutter/material.dart';
import '../parser/time_expression_parser.dart';
import '../theme/app_theme_palette.dart';

abstract final class ExpressionSpanFormatter {
  static final RegExp _expressionHighlightRegex = () {
    final escapedUnits =
        TimeExpressionParser.unitCandidates.map(RegExp.escape).join('|');
    const operators = r':|[+\-−×*÷/%()]';
    return RegExp('($escapedUnits|$operators)');
  }();

  static TextSpan build(
    String expression,
    ThemeData theme,
    double fontSize,
  ) {
    final spans = <InlineSpan>[];
    final palette = AppThemePalette.ofTheme(theme);
    final defaultStyle = theme.textTheme.titleLarge?.copyWith(
      color: palette.textLight,
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final unitStyle = defaultStyle?.copyWith(color: palette.syntaxUnit);
    final operatorStyle =
        defaultStyle?.copyWith(color: palette.syntaxOperator);

    final matches = _expressionHighlightRegex.allMatches(expression);

    var cursor = 0;
    for (final match in matches) {
      if (match.start > cursor) {
        spans.add(
          TextSpan(
            text: expression.substring(cursor, match.start),
            style: defaultStyle,
          ),
        );
      }
      final token = match.group(0)!;
      final isOperator = const [
        '+',
        '-',
        '−',
        '×',
        '*',
        '÷',
        '/',
        '(',
        ')',
        ':',
        '%',
      ].contains(token);
      spans.add(
        TextSpan(
          text: token,
          style: isOperator ? operatorStyle : unitStyle,
        ),
      );
      cursor = match.end;
    }
    if (cursor < expression.length) {
      spans.add(
        TextSpan(text: expression.substring(cursor), style: defaultStyle),
      );
    }
    return TextSpan(children: spans, style: defaultStyle);
  }
}

/// 既存コード互換用のトップレベル関数
TextSpan buildExpressionSpan(
  String expression,
  ThemeData theme,
  double fontSize,
) =>
    ExpressionSpanFormatter.build(expression, theme, fontSize);
