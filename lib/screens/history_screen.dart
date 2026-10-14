import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/app_dimensions.dart';
import '../l10n/app_strings.dart';
import '../models/calculation_record.dart';
import '../models/expression_value.dart';
import '../services/app_settings.dart';
import '../services/history_storage.dart';
import '../theme/app_theme_palette.dart';
import '../utils/time_formatter.dart';
import '../widgets/history_card.dart';
import '../widgets/label_edit_dialog.dart';
import 'conversion_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.storage, this.settings});

  final HistoryStorage storage;
  final AppSettings? settings;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<CalculationRecord> _records;

  @override
  void initState() {
    super.initState();
    _records = List.of(widget.storage.records);
  }

  Future<void> _refresh() async {
    await widget.storage.load();
    if (!mounted) return;
    setState(() {
      _records = List.of(widget.storage.records);
    });
  }

  void _copyAllHistory(AppStrings strings) {
    if (_records.isEmpty) return;
    final buffer = StringBuffer();
    buffer.writeln('【${strings.appTitle} - ${strings.history}】');
    for (final r in _records) {
      final labelStr = r.label?.isNotEmpty == true ? ' [${r.label}]' : '';
      buffer.writeln('・${r.expression} = ${r.resultText}$labelStr');
    }
    var totalSeconds = 0.0;
    var durationCount = 0;
    for (final r in _records) {
      if (r.seconds != null) {
        totalSeconds += r.seconds!;
        durationCount++;
      }
    }
    if (durationCount > 0) {
      buffer.writeln('--------------------');
      buffer.writeln(
        '${strings.totalDurationHeader}: ${TimeFormatter.formatDuration(totalSeconds, strings.units)} (${TimeFormatter.formatSummaryConversions(totalSeconds, strings.units)}) [${_records.length}${strings.itemCountSuffix}]',
      );
    }
    final text = buffer.toString().trim();
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(strings.copiedHistoryToast),
        duration: AppDimensions.toastDuration,
      ),
    );
  }

  Future<void> _clearAll(AppStrings strings, AppThemePalette palette) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(strings.clearAllConfirmTitle),
        content: Text(strings.clearAllConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: palette.danger,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(strings.delete),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await widget.storage.clearAll();
      await _refresh();
    }
  }

  Widget _buildSummaryHeader(AppStrings strings, AppThemePalette palette) {
    var totalSeconds = 0.0;
    var durationCount = 0;
    for (final r in _records) {
      if (r.seconds != null) {
        totalSeconds += r.seconds!;
        durationCount++;
      }
    }
    if (durationCount == 0) return const SizedBox.shrink();

    final formattedTotal =
        TimeFormatter.formatDuration(totalSeconds, strings.units);
    final summaryConversions =
        TimeFormatter.formatSummaryConversions(totalSeconds, strings.units);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            palette.historyGradientStart,
            palette.historyGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: palette.primary.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.functions,
                color: palette.historySummaryIcon,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                strings.totalDurationHeader,
                style: TextStyle(
                  color: palette.textLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_records.length}${strings.itemCountSuffix}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formattedTotal,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '($summaryConversions)',
            style: TextStyle(
              color: palette.textLight,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppThemePalette.of(context);
    final strings = AppStrings.of(context, widget.settings?.language);
    final localeStr = widget.settings?.language.locale?.toString();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        title: Text(strings.history),
        actions: [
          if (_records.isNotEmpty) ...[
            IconButton(
              tooltip: strings.copyAllHistory,
              onPressed: () => _copyAllHistory(strings),
              icon: const Icon(Icons.copy_all_outlined),
            ),
            IconButton(
              tooltip: strings.clearAllHistory,
              onPressed: () => _clearAll(strings, palette),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
          ],
        ],
      ),
      body: _records.isEmpty
          ? Center(child: Text(strings.historyEmpty))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
              itemCount: _records.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildSummaryHeader(strings, palette);
                }
                final item = _records[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: HistoryCard(
                    record: item,
                    strings: strings,
                    locale: localeStr,
                    onSelect: () => Navigator.of(context).pop(item.expression),
                    onEditLabel: () async {
                      final label = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.black45,
                        builder: (_) => LabelEditDialog(
                          expression: item.expression,
                          resultText: item.resultText,
                          initialLabel: item.label,
                          strings: strings,
                        ),
                      );
                      if (label != null) {
                        await widget.storage.upsert(
                          item.copyWith(label: label),
                        );
                        await _refresh();
                      }
                    },
                    onDelete: () async {
                      await widget.storage.delete(item.id);
                      await _refresh();
                    },
                    onShare: () async {
                      await SharePlus.instance.share(
                        ShareParams(
                          text:
                              '${strings.sharePrefix}\n${item.label?.trim().isNotEmpty == true ? '${item.label}\n' : ''}${item.expression} = ${item.resultText}',
                        ),
                      );
                    },
                    onConvert: item.seconds == null
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => ConversionScreen(
                                  result:
                                      ExpressionValue.duration(item.seconds!),
                                  settings: widget.settings,
                                ),
                              ),
                            );
                          },
                  ),
                );
              },
            ),
    );
  }
}
