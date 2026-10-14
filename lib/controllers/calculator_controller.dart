import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../models/calculation_record.dart';
import '../models/calculator_state.dart';
import '../parser/time_expression_parser.dart';
import '../services/app_settings.dart';
import '../services/history_storage.dart';
import '../utils/time_formatter.dart';

class CalculatorController extends ChangeNotifier {
  CalculatorController({
    required this.storage,
    required this.settings,
    TimeExpressionParser? parser,
  }) : _parser = parser ?? TimeExpressionParser() {
    _state = CalculatorState.initial(history: List.of(storage.records));
  }

  final HistoryStorage storage;
  final AppSettings settings;
  final TimeExpressionParser _parser;

  UnitLabels get _currentUnits => AppStrings.get(settings.language).units;

  CalculatorState _state = const CalculatorState();
  CalculatorState get state => _state;

  String get expression => _state.expression;
  List<CalculationRecord> get history => _state.history;

  String get _lastChar =>
      _state.expression.isEmpty ? '' : _state.expression.characters.last;

  bool _isDigit(String char) => RegExp(r'[0-9]').hasMatch(char);

  bool _isOperator(String char) =>
      const ['+', '-', '−', '×', '÷', '%'].contains(char);

  /// 多言語単位（日本語、英語、その他31言語）のいずれかで式が終わっているかを判定
  bool _endsWithUnit(String expr) {
    if (expr.isEmpty) return false;
    for (final candidate in TimeExpressionParser.unitCandidates) {
      if (expr.endsWith(candidate)) {
        return true;
      }
    }
    return false;
  }

  Future<void> reloadHistory() async {
    await storage.load();
    _state = _state.copyWith(history: List.of(storage.records));
    notifyListeners();
  }

  void appendText(String value) {
    var expr = _state.expression;
    final wasEvaluated = _state.isEvaluated;
    var evaluated = wasEvaluated;
    String? evalExpr = _state.evaluatedExpression;

    if (evaluated) {
      evaluated = false;
      evalExpr = null;
      if (!_isOperator(value)) {
        expr = '';
      }
    }

    final last = expr.isEmpty ? '' : expr.characters.last;
    final endsWithUnit = _endsWithUnit(expr);

    // 00 の入力調整
    if (value == '00') {
      if (expr.isEmpty || _isOperator(last) || last == '(') {
        value = '0';
      }
    }

    // 1. 数字の入力制限
    if (_isDigit(value)) {
      if (endsWithUnit || last == ')') {
        return;
      }
      var currentNumberLen = 0;
      final chars = expr.characters.toList();
      for (var i = chars.length - 1; i >= 0; i--) {
        final c = chars[i];
        if (_isDigit(c) || c == '.') {
          currentNumberLen++;
        } else {
          break;
        }
      }
      if (currentNumberLen + value.length > 15) {
        return;
      }
    }

    // 1.5 コロン (:) の入力制限
    if (value == ':') {
      if (!_isDigit(last)) {
        return;
      }
      var colonCount = 0;
      final chars = expr.characters.toList();
      for (var i = chars.length - 1; i >= 0; i--) {
        final c = chars[i];
        if (c == ':') {
          colonCount++;
        } else if (!_isDigit(c)) {
          break;
        }
      }
      if (colonCount >= 2) {
        return;
      }
    }

    // 2. 小数点 (.) の入力制限
    if (value == '.') {
      if (endsWithUnit || last == ')') {
        return;
      }
      var currentNumberLen = 0;
      final chars = expr.characters.toList();
      for (var i = chars.length - 1; i >= 0; i--) {
        final c = chars[i];
        if (_isDigit(c) || c == '.') {
          currentNumberLen++;
        } else {
          break;
        }
      }
      if (currentNumberLen + 1 > 15) {
        return;
      }
      if (!_isDigit(last)) {
        expr += '0.';
        _updateExpression(
          expr,
          isEvaluated: evaluated,
          evaluatedExpression: evalExpr,
          clearEvaluatedExpression: wasEvaluated,
        );
        return;
      }
      var hasDot = false;
      for (var i = chars.length - 1; i >= 0; i--) {
        final c = chars[i];
        if (c == '.') {
          hasDot = true;
          break;
        }
        if (!_isDigit(c)) {
          break;
        }
      }
      if (hasDot) {
        return;
      }
    }

    // 3. 演算子 (+, -, ×, ÷) の入力制限
    if (_isOperator(value)) {
      if (expr.isEmpty) {
        if (value != '-' && value != '−') {
          return;
        }
      } else if (last == '(') {
        if (value != '-' && value != '−') {
          return;
        }
      } else if (_isOperator(last)) {
        if (value == '-' || value == '−') {
          if (last == '-' || last == '−') {
            return;
          }
        } else {
          expr = expr.characters.skipLast(1).toString();
          if (expr.isNotEmpty && _isOperator(expr.characters.last)) {
            expr = expr.characters.skipLast(1).toString();
          }
          expr += value;
          _updateExpression(
            expr,
            isEvaluated: evaluated,
            evaluatedExpression: evalExpr,
            clearEvaluatedExpression: wasEvaluated,
          );
          return;
        }
      } else if (last == ':') {
        expr = expr.characters.skipLast(1).toString();
        expr += value;
        _updateExpression(
          expr,
          isEvaluated: evaluated,
          evaluatedExpression: evalExpr,
          clearEvaluatedExpression: wasEvaluated,
        );
        return;
      } else if (last == '.') {
        return;
      }
    }

    // 4. パーセント (%) の入力制限
    if (value == '%') {
      if (!_isDigit(last) && !endsWithUnit && last != ')') {
        return;
      }
    }

    // 5. 開き括弧 ( の入力制限
    if (value == '(') {
      if (_isDigit(last) || endsWithUnit || last == ')') {
        return;
      }
    }

    // 6. 閉じ括弧 ) の入力制限
    if (value == ')') {
      if (last == '(' || _isOperator(last) || last == '.' || last == ':') {
        return;
      }
      final openCount = expr.split('(').length - 1;
      final closeCount = expr.split(')').length - 1;
      if (closeCount >= openCount) {
        return;
      }
    }

    expr += value;
    _updateExpression(
      expr,
      isEvaluated: evaluated,
      evaluatedExpression: evalExpr,
      clearEvaluatedExpression: wasEvaluated,
    );
  }

  void appendUnit(String unit) {
    var expr = _state.expression;
    final wasEvaluated = _state.isEvaluated;

    final last = expr.isEmpty ? '' : expr.characters.last;

    // 単位は直前が数字の場合のみ許可する
    if (!_isDigit(last)) {
      return;
    }

    // 直前の数値トークンがコロン時刻リテラルに属している場合は単位付与を禁止
    final chars = expr.characters.toList();
    for (var i = chars.length - 1; i >= 0; i--) {
      final c = chars[i];
      if (c == ':') {
        return;
      }
      if (!_isDigit(c) && c != '.') {
        break;
      }
    }

    expr += unit;
    _updateExpression(
      expr,
      isEvaluated: false,
      clearEvaluatedExpression: wasEvaluated,
    );
  }

  void backspace() {
    if (_state.expression.isEmpty) {
      return;
    }
    final newExpr = _state.expression.characters.skipLast(1).toString();
    _updateExpression(
      newExpr,
      isEvaluated: false,
      clearEvaluatedExpression: true,
    );
  }

  void clear() {
    _updateExpression(
      '',
      isEvaluated: false,
      clearEvaluatedExpression: true,
    );
  }

  void appendParenthesis() {
    var expr = _state.expression;
    if (_state.isEvaluated) {
      _updateExpression(
        '(',
        isEvaluated: false,
        clearEvaluatedExpression: true,
      );
      return;
    }

    final openCount = expr.split('(').length - 1;
    final closeCount = expr.split(')').length - 1;
    final last = _lastChar;
    final endsWithUnit = _endsWithUnit(expr);

    // 1. 式が空、または直前が演算子か開き括弧の場合 -> '(' を追加
    if (expr.isEmpty || _isOperator(last) || last == '(') {
      _updateExpression('$expr(');
      return;
    }

    // 2. 開き括弧が未完了で、直前が数字・単位・閉じ括弧の場合 -> ')' を追加
    if (openCount > closeCount &&
        (_isDigit(last) || endsWithUnit || last == ')')) {
      _updateExpression('$expr)');
      return;
    }

    // 3. 直前が数字・単位・閉じ括弧で既に閉じている場合 -> 暗黙の掛け算 '×(' を追加
    if (_isDigit(last) || endsWithUnit || last == ')') {
      _updateExpression('$expr×(');
      return;
    }

    // それ以外 -> '(' を追加
    _updateExpression('$expr(');
  }

  void restoreExpression(String expr) {
    _updateExpression(
      expr,
      isEvaluated: false,
      clearEvaluatedExpression: true,
    );
  }

  Future<void> saveCurrentCalculation({String? label, bool notify = true}) async {
    final preview = _state.preview;
    if (preview == null || !preview.isValid) {
      return;
    }
    final units = _currentUnits;
    final normalizedExpr =
        TimeFormatter.normalizeExpressionUnits(_state.expression);
    final resultText = preview.formatDisplayText(units);
    final record = CalculationRecord(
      id: CalculationRecord.generateId(),
      label: label?.trim().isEmpty ?? true ? null : label?.trim(),
      expression: normalizedExpr,
      resultText: resultText,
      seconds: preview.value?.durationSeconds,
      scalar: preview.value?.scalar,
      createdAt: DateTime.now(),
    );
    await storage.upsert(record);
    if (notify) {
      await reloadHistory();
    } else {
      await storage.load();
      _state = _state.copyWith(history: List.of(storage.records));
    }
  }

  Future<void> commitCalculation() async {
    final preview = _state.preview;
    final expr = _state.expression;
    if (preview == null || !preview.isValid || expr.trim().isEmpty) {
      return;
    }
    if (_state.isEvaluated) {
      return;
    }
    final units = _currentUnits;
    final resultText = preview.formatDisplayText(units);
    final normalizedExpr =
        TimeFormatter.normalizeExpressionUnits(expr);
    final latest = _state.history.isEmpty ? null : _state.history.first;
    final isSame = latest != null &&
        latest.expression == normalizedExpr &&
        latest.resultText == resultText;
    if (!isSame) {
      await saveCurrentCalculation(notify: false);
    }
    final currentExpr = expr;

    String? derivedUnit;
    if (resultText.isNotEmpty) {
      for (final candidate in TimeExpressionParser.unitCandidates) {
        if (resultText.endsWith(candidate)) {
          derivedUnit = candidate;
          break;
        }
      }
    }

    _state = _state.copyWith(
      evaluatedExpression: currentExpr,
      expression: resultText,
      activeUnit: derivedUnit,
      clearActiveUnit: derivedUnit == null,
      isEvaluated: true,
      preview: _parser.evaluate(resultText),
    );
    notifyListeners();
  }

  void _updateExpression(
    String newExpr, {
    bool? isEvaluated,
    String? evaluatedExpression,
    bool clearEvaluatedExpression = false,
  }) {
    final preview =
        newExpr.trim().isEmpty ? null : _parser.evaluate(newExpr);

    String? derivedUnit;
    if (newExpr.isNotEmpty) {
      for (final candidate in TimeExpressionParser.unitCandidates) {
        if (newExpr.endsWith(candidate)) {
          derivedUnit = candidate;
          break;
        }
      }
    }

    _state = _state.copyWith(
      expression: newExpr,
      activeUnit: derivedUnit,
      clearActiveUnit: derivedUnit == null,
      isEvaluated: isEvaluated,
      evaluatedExpression: evaluatedExpression,
      clearEvaluatedExpression: clearEvaluatedExpression,
      preview: preview,
      clearPreview: preview == null,
    );
    notifyListeners();
  }
}
