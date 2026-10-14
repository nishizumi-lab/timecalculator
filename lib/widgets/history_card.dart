import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';
import '../l10n/app_strings.dart';
import '../models/calculation_record.dart';
import '../theme/app_theme_palette.dart';
import '../utils/time_formatter.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.record,
    required this.strings,
    this.locale,
    required this.onSelect,
    required this.onEditLabel,
    required this.onDelete,
    required this.onShare,
    required this.onConvert,
  });

  final CalculationRecord record;
  final AppStrings strings;
  final String? locale;
  final VoidCallback onSelect;
  final VoidCallback onEditLabel;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final VoidCallback? onConvert;

  @override
  Widget build(BuildContext context) {
    final palette = AppThemePalette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: palette.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        record.resultText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 4,
                      child: Text(
                        record.expression,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: palette.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                if (record.label?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: palette.accent.withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                    child: Text(
                      record.label!,
                      style: TextStyle(
                        fontSize: 12,
                        color: palette.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: palette.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      TimeFormatter.formatRelativeDate(
                        record.createdAt,
                        strings,
                        locale,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: palette.textMuted,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: strings.editLabel,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.label_outline, size: 18),
                      onPressed: onEditLabel,
                    ),
                    if (onConvert != null)
                      IconButton(
                        tooltip: strings.conversionsTitle,
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.swap_horiz, size: 18),
                        onPressed: onConvert,
                      ),
                    IconButton(
                      tooltip: strings.share,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.share_outlined, size: 18),
                      onPressed: onShare,
                    ),
                    IconButton(
                      tooltip: strings.delete,
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: palette.danger,
                      ),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
