import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/app_dimensions.dart';
import '../controllers/calculator_controller.dart';
import '../l10n/app_strings.dart';
import '../models/expression_value.dart';
import '../services/app_settings.dart';
import '../services/history_storage.dart';
import '../theme/app_theme_palette.dart';
import '../utils/expression_span.dart';
import '../utils/time_formatter.dart';
import '../widgets/keypad_button.dart';
import 'conversion_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';


class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({
    super.key,
    required this.storage,
    required this.settings,
    this.controller,
  });

  final HistoryStorage storage;
  final AppSettings settings;
  final CalculatorController? controller;

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late final CalculatorController _controller;
  final ScrollController _expressionScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        CalculatorController(
          storage: widget.storage,
          settings: widget.settings,
        );
  }

  @override
  void dispose() {
    _expressionScroll.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _triggerHaptic() {
    if (widget.settings.vibrationEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  void _scrollExpressionToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_expressionScroll.hasClients) {
        return;
      }
      _expressionScroll.animateTo(
        0,
        duration: AppDimensions.animScroll,
        curve: Curves.easeOut,
      );
    });
  }

  void _onKeypadText(String text) {
    _triggerHaptic();
    _controller.appendText(text);
    _scrollExpressionToEnd();
  }

  void _onKeypadUnit(String unit) {
    _triggerHaptic();
    _controller.appendUnit(unit);
    _scrollExpressionToEnd();
  }

  void _onKeypadParenthesis() {
    _triggerHaptic();
    _controller.appendParenthesis();
    _scrollExpressionToEnd();
  }

  void _onBackspace() {
    _triggerHaptic();
    _controller.backspace();
  }

  void _onClear() {
    _triggerHaptic();
    _controller.clear();
  }

  Future<void> _onCommitCalculation() async {
    _triggerHaptic();
    await _controller.commitCalculation();
    _scrollExpressionToEnd();
  }

  Future<void> _openSettingsScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsScreen(settings: widget.settings),
      ),
    );
  }

  Future<void> _showHistory() async {
    final selectedExpr = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => HistoryScreen(
          storage: widget.storage,
          settings: widget.settings,
        ),
      ),
    );
    await _controller.reloadHistory();
    if (selectedExpr != null && mounted) {
      _triggerHaptic();
      _controller.restoreExpression(selectedExpr);
      _scrollExpressionToEnd();
    }
  }

  Future<void> _showConversion() async {
    final preview = _controller.state.preview;
    if (preview?.value?.kind != ValueKind.duration) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ConversionScreen(
          result: preview!.value!,
          settings: widget.settings,
        ),
      ),
    );
  }

  Future<void> _shareCurrent() async {
    final preview = _controller.state.preview;
    final expr = _controller.state.isEvaluated &&
            _controller.state.evaluatedExpression != null
        ? _controller.state.evaluatedExpression!
        : _controller.state.expression;
    if (preview == null || !preview.isValid) {
      return;
    }
    final strings = AppStrings.of(context, widget.settings.language);
    final resultText = preview.formatDisplayText(strings.units);
    await SharePlus.instance.share(
      ShareParams(
        text: '${strings.sharePrefix}\n${expr.trim()} = $resultText',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppThemePalette.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final strings = AppStrings.of(context, widget.settings.language);

    final screenHeight = MediaQuery.sizeOf(context).height;
    final keypadHeight = (screenHeight * AppDimensions.keypadHeightRatio)
        .clamp(AppDimensions.keypadMinHeight, AppDimensions.keypadMaxHeight);

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final state = _controller.state;
        final history = state.history;
        final preview = state.preview;

        return Scaffold(
          appBar: AppBar(
            title: Text(strings.appTitle),
            actions: [
              IconButton(
                onPressed: _shareCurrent,
                icon: const Icon(Icons.share_outlined),
              ),
              IconButton(
                onPressed: _showHistory,
                icon: const Icon(Icons.history),
              ),
              IconButton(
                onPressed: _openSettingsScreen,
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity != null &&
                          details.primaryVelocity!.abs() > 100) {
                        _onBackspace();
                      }
                    },
                    child: Padding(
                      padding: AppDimensions.screenPadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 0. 上部の直近履歴タイムライン
                          if (history.isNotEmpty)
                            Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (var i = 0;
                                      i < history.take(2).length;
                                      i++) ...[
                                    if (i > 0) const SizedBox(height: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: palette.textPrimary.withValues(
                                          alpha: i == 0 ? 0.08 : 0.04,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.radiusBadge,
                                        ),
                                        border: Border.all(
                                          color: palette.textPrimary.withValues(
                                            alpha: i == 0 ? 0.06 : 0.03,
                                          ),
                                        ),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            _triggerHaptic();
                                            _controller.restoreExpression(
                                              history[i].expression,
                                            );
                                            _scrollExpressionToEnd();
                                          },
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.radiusBadge,
                                          ),
                                          child: Padding(
                                            padding: AppDimensions
                                                .historyTimelinePadding,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.history,
                                                  size: 13,
                                                  color: i == 0
                                                      ? palette.textMuted
                                                      : palette.textMuted.withValues(alpha: 0.4),
                                                ),
                                                const SizedBox(width: 5),
                                                Flexible(
                                                  child: Text(
                                                    '${history[i].expression} = ${history[i].resultText}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: i == 0
                                                          ? palette.textLight
                                                          : palette.textMuted.withValues(alpha: 0.5),
                                                      fontSize: 12,
                                                      fontWeight: i == 0
                                                          ? FontWeight.w500
                                                          : FontWeight.w400,
                                                      fontFeatures: const [
                                                        FontFeature
                                                            .tabularFigures(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            )
                          else
                            const SizedBox.shrink(),
                          const Spacer(),
                          // 1. 入力式エリア
                          Flexible(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: SingleChildScrollView(
                                controller: _expressionScroll,
                                reverse: true,
                                scrollDirection: Axis.horizontal,
                                child: SelectableText.rich(
                                  state.isEvaluated &&
                                          state.evaluatedExpression != null
                                      ? TextSpan(
                                          children: [
                                            ExpressionSpanFormatter.build(
                                              state.evaluatedExpression!,
                                              theme,
                                              _getExpressionFontSize(
                                                state.evaluatedExpression!,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' =',
                                              style: TextStyle(
                                                color: palette.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    _getExpressionFontSize(
                                                  state.evaluatedExpression!,
                                                ),
                                                fontFeatures: const [
                                                  FontFeature.tabularFigures(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : ExpressionSpanFormatter.build(
                                          state.expression.isEmpty
                                              ? '0'
                                              : state.expression,
                                          theme,
                                          _getExpressionFontSize(
                                            state.expression,
                                          ),
                                        ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 2. 出力結果エリア
                          Flexible(
                            flex: 4,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.bottomRight,
                                child: preview != null && !preview.isValid
                                    ? Text(
                                        preview.formatErrorMessage(strings) ??
                                            preview.error ??
                                            '',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: theme.colorScheme.error,
                                        ),
                                      )
                                    : GestureDetector(
                                        onLongPress: () {
                                          final text = preview?.formatDisplayText(
                                            strings.units,
                                          );
                                          if (text != null &&
                                              text.isNotEmpty &&
                                              text != '...') {
                                            _triggerHaptic();
                                            Clipboard.setData(
                                              ClipboardData(text: text),
                                            );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  strings.copiedResultToast(
                                                    text,
                                                  ),
                                                ),
                                                duration:
                                                    AppDimensions.toastDuration,
                                              ),
                                            );
                                          }
                                        },
                                        child: Text(
                                          preview?.formatDisplayText(
                                                strings.units,
                                              ) ??
                                              '',
                                          style: theme.textTheme.displayMedium
                                              ?.copyWith(
                                            color: palette.textPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontFeatures: const [
                                              FontFeature.tabularFigures(),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // 3. 換算表示エリア
                          Flexible(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.bottomRight,
                                child: preview != null &&
                                        preview.isValid &&
                                        preview.value?.kind ==
                                            ValueKind.duration
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: palette.textPrimary.withValues(
                                            alpha: 0.07,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.radiusCard,
                                          ),
                                          border: Border.all(
                                            color: palette.cardBorder,
                                          ),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: _showConversion,
                                            onLongPress: () {
                                              _triggerHaptic();
                                              final summary = TimeFormatter
                                                  .formatSummaryConversions(
                                                preview.value!.durationSeconds!,
                                                strings.units,
                                              );
                                              Clipboard.setData(
                                                ClipboardData(text: summary),
                                              );
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    strings
                                                        .copiedConversionToast(
                                                      summary,
                                                    ),
                                                  ),
                                                  duration: AppDimensions
                                                      .toastDuration,
                                                ),
                                              );
                                            },
                                            borderRadius:
                                                BorderRadius.circular(
                                              AppDimensions.radiusCard,
                                            ),
                                            child: Padding(
                                              padding: AppDimensions
                                                  .conversionBadgePadding,
                                              child: Text(
                                                '(${TimeFormatter.formatSummaryConversions(preview.value!.durationSeconds!, strings.units)})',
                                                style: TextStyle(
                                                  color: palette.textLight,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: keypadHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(
                          AppDimensions.radiusKeypadTop,
                        ),
                        topRight: Radius.circular(
                          AppDimensions.radiusKeypadTop,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.24 : 0.06,
                          ),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: AppDimensions.keypadPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (final unit in [
                                  strings.units.year,
                                  strings.units.month,
                                  strings.units.week,
                                  strings.units.day,
                                ])
                                  Expanded(
                                    child: KeypadButton(
                                      label: unit,
                                      kind: KeyKind.unit,
                                      isActive: state.activeUnit == unit,
                                      onTap: () => _onKeypadUnit(unit),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (final unit in [
                                  strings.units.hour,
                                  strings.units.minute,
                                  strings.units.second,
                                ])
                                  Expanded(
                                    child: KeypadButton(
                                      label: unit,
                                      kind: KeyKind.unit,
                                      isActive: state.activeUnit == unit,
                                      onTap: () => _onKeypadUnit(unit),
                                    ),
                                  ),
                                Expanded(
                                  child: KeypadButton(
                                    icon: Icons.backspace_outlined,
                                    semanticsLabel:
                                        strings.semanticsKeypad('backspace'),
                                    backgroundColor: palette.deleteKey,
                                    foregroundColor:
                                        palette.deleteKeyForeground,
                                    onTap: _onBackspace,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                _buildKeypadRow([
                                  KeySpec.text(
                                    'C',
                                    kind: KeyKind.soft,
                                    semanticsLabel: strings.semanticsKeypad('C'),
                                    onTap: _onClear,
                                  ),
                                  KeySpec.text(
                                    '( )',
                                    kind: KeyKind.soft,
                                    semanticsLabel:
                                        strings.semanticsKeypad('paren'),
                                    onTap: _onKeypadParenthesis,
                                  ),
                                  KeySpec.text(
                                    ':',
                                    kind: KeyKind.soft,
                                    semanticsLabel: strings.semanticsKeypad(':'),
                                    onTap: () => _onKeypadText(':'),
                                  ),
                                  KeySpec.text(
                                    '÷',
                                    kind: KeyKind.operator,
                                    semanticsLabel: strings.semanticsKeypad('÷'),
                                    onTap: () => _onKeypadText('÷'),
                                  ),
                                ]),
                                _buildKeypadRow([
                                  KeySpec.text(
                                    '7',
                                    onTap: () => _onKeypadText('7'),
                                  ),
                                  KeySpec.text(
                                    '8',
                                    onTap: () => _onKeypadText('8'),
                                  ),
                                  KeySpec.text(
                                    '9',
                                    onTap: () => _onKeypadText('9'),
                                  ),
                                  KeySpec.text(
                                    '×',
                                    kind: KeyKind.operator,
                                    semanticsLabel: strings.semanticsKeypad('×'),
                                    onTap: () => _onKeypadText('×'),
                                  ),
                                ]),
                                _buildKeypadRow([
                                  KeySpec.text(
                                    '4',
                                    onTap: () => _onKeypadText('4'),
                                  ),
                                  KeySpec.text(
                                    '5',
                                    onTap: () => _onKeypadText('5'),
                                  ),
                                  KeySpec.text(
                                    '6',
                                    onTap: () => _onKeypadText('6'),
                                  ),
                                  KeySpec.text(
                                    '−',
                                    kind: KeyKind.operator,
                                    semanticsLabel: strings.semanticsKeypad('−'),
                                    onTap: () => _onKeypadText('-'),
                                  ),
                                ]),
                                _buildKeypadRow([
                                  KeySpec.text(
                                    '1',
                                    onTap: () => _onKeypadText('1'),
                                  ),
                                  KeySpec.text(
                                    '2',
                                    onTap: () => _onKeypadText('2'),
                                  ),
                                  KeySpec.text(
                                    '3',
                                    onTap: () => _onKeypadText('3'),
                                  ),
                                  KeySpec.text(
                                    '+',
                                    kind: KeyKind.operator,
                                    semanticsLabel: strings.semanticsKeypad('+'),
                                    onTap: () => _onKeypadText('+'),
                                  ),
                                ]),
                                _buildBottomRow(strings),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeypadRow(List<KeySpec> specs) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final spec in specs)
            Expanded(
              child: KeypadButton(
                label: spec.label,
                icon: spec.icon,
                kind: spec.kind,
                semanticsLabel: spec.semanticsLabel,
                onTap: spec.onTap,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomRow(AppStrings strings) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: KeypadButton(label: '0', onTap: () => _onKeypadText('0')),
          ),
          Expanded(
            child: KeypadButton(label: '00', onTap: () => _onKeypadText('00')),
          ),
          Expanded(
            child: KeypadButton(
              label: '.',
              semanticsLabel: strings.semanticsKeypad('.'),
              onTap: () => _onKeypadText('.'),
            ),
          ),
          Expanded(
            child: KeypadButton(
              label: '=',
              semanticsLabel: strings.semanticsKeypad('='),
              kind: KeyKind.equal,
              onTap: _onCommitCalculation,
            ),
          ),
        ],
      ),
    );
  }

  double _getExpressionFontSize(String text) {
    final len = text.length;
    if (len <= AppDimensions.expressionLengthMediumThreshold) {
      return AppDimensions.expressionLarge;
    }
    if (len <= AppDimensions.expressionLengthSmallThreshold) {
      return AppDimensions.expressionMedium;
    }
    return AppDimensions.expressionSmall;
  }
}
