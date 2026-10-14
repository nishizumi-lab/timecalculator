import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../models/calculation_record.dart';
import '../models/duration_unit.dart';
import '../models/expression_value.dart';
import '../services/app_settings.dart';
import '../utils/time_formatter.dart';

class ConversionScreen extends StatelessWidget {
  const ConversionScreen({super.key, required this.result, this.settings});

  final ExpressionValue result;
  final AppSettings? settings;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context, settings?.language);
    final seconds = result.durationSeconds ?? 0;
    final rows = [
      ConversionRow(strings.units.year, seconds / DurationUnit.year.seconds),
      ConversionRow(strings.units.month, seconds / DurationUnit.month.seconds),
      ConversionRow(strings.units.week, seconds / DurationUnit.week.seconds),
      ConversionRow(strings.units.day, seconds / DurationUnit.day.seconds),
      ConversionRow(strings.units.hour, seconds / DurationUnit.hour.seconds),
      ConversionRow(strings.units.minute, seconds / DurationUnit.minute.seconds),
      ConversionRow(strings.units.second, seconds),
      ConversionRow('ms', seconds * 1000),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        title: Text(strings.conversionsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        children: [
          Center(
            child: Text(
              TimeFormatter.formatDuration(seconds, strings.units),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 18),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '${TimeFormatter.formatDecimal(row.value)} ${row.label}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
