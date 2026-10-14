import 'calculation_record.dart';
import 'expression_value.dart';

class CalculatorState {
  const CalculatorState({
    this.expression = '',
    this.evaluatedExpression,
    this.activeUnit,
    this.preview,
    this.isEvaluated = false,
    this.history = const [],
  });

  factory CalculatorState.initial({List<CalculationRecord> history = const []}) {
    return CalculatorState(history: history);
  }

  final String expression;
  final String? evaluatedExpression;
  final String? activeUnit;
  final EvaluationState? preview;
  final bool isEvaluated;
  final List<CalculationRecord> history;

  CalculatorState copyWith({
    String? expression,
    String? evaluatedExpression,
    bool clearEvaluatedExpression = false,
    String? activeUnit,
    bool clearActiveUnit = false,
    EvaluationState? preview,
    bool clearPreview = false,
    bool? isEvaluated,
    List<CalculationRecord>? history,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      evaluatedExpression: clearEvaluatedExpression
          ? null
          : (evaluatedExpression ?? this.evaluatedExpression),
      activeUnit: clearActiveUnit ? null : (activeUnit ?? this.activeUnit),
      preview: clearPreview ? null : (preview ?? this.preview),
      isEvaluated: isEvaluated ?? this.isEvaluated,
      history: history ?? this.history,
    );
  }
}
