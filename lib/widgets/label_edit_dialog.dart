import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme_palette.dart';

class LabelEditDialog extends StatefulWidget {
  const LabelEditDialog({
    super.key,
    required this.expression,
    required this.resultText,
    this.initialLabel,
    required this.strings,
  });

  final String expression;
  final String resultText;
  final String? initialLabel;
  final AppStrings strings;

  @override
  State<LabelEditDialog> createState() => _LabelEditDialogState();
}

class _LabelEditDialogState extends State<LabelEditDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialLabel ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppThemePalette.of(context);
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 16 + viewInsets),
      child: Material(
        color: palette.surface,
        borderRadius: BorderRadius.circular(2),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.strings.editLabel,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.strings.labelHint,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: palette.accent,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                widget.expression,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '= ${widget.resultText}',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 22),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: palette.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                onPressed: () =>
                    Navigator.of(context).pop(_controller.text.trim()),
                child: Text(widget.strings.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
