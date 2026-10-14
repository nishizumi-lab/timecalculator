import 'dart:math';

class CalculationRecord {
  CalculationRecord({
    required this.id,
    required this.expression,
    required this.resultText,
    required this.createdAt,
    this.label,
    this.seconds,
    this.scalar,
  });

  final String id;
  final String expression;
  final String resultText;
  final DateTime createdAt;
  final String? label;
  final double? seconds;
  final double? scalar;

  static String generateId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final random = Random().nextInt(1000000);
    return '${timestamp}_$random';
  }

  CalculationRecord copyWith({String? label}) {
    return CalculationRecord(
      id: id,
      expression: expression,
      resultText: resultText,
      createdAt: createdAt,
      label: label,
      seconds: seconds,
      scalar: scalar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expression': expression,
      'resultText': resultText,
      'createdAt': createdAt.toIso8601String(),
      'label': label,
      'seconds': seconds,
      'scalar': scalar,
    };
  }

  factory CalculationRecord.fromJson(Map<String, dynamic> json) {
    return CalculationRecord(
      id: json['id'] as String,
      expression: json['expression'] as String,
      resultText: json['resultText'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      label: json['label'] as String?,
      seconds: (json['seconds'] as num?)?.toDouble(),
      scalar: (json['scalar'] as num?)?.toDouble(),
    );
  }
}

class ConversionRow {
  ConversionRow(this.label, this.value);

  final String label;
  final double value;
}
