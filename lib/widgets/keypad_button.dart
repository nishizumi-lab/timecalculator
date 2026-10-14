import 'package:flutter/material.dart';
import '../theme/app_theme_palette.dart';

enum KeyKind { normal, operator, soft, equal, unit }

class KeySpec {
  KeySpec.text(
    this.label, {
    required this.onTap,
    this.kind = KeyKind.normal,
    this.semanticsLabel,
  }) : icon = null;

  KeySpec.icon(
    this.icon, {
    required this.onTap,
    this.kind = KeyKind.normal,
    this.semanticsLabel,
  }) : label = null;

  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final KeyKind kind;
  final String? semanticsLabel;
}

class KeypadButton extends StatelessWidget {
  const KeypadButton({
    super.key,
    this.label,
    this.icon,
    this.kind = KeyKind.normal,
    this.isActive = false,
    this.backgroundColor,
    this.foregroundColor,
    this.semanticsLabel,
    required this.onTap,
  });

  final String? label;
  final IconData? icon;
  final KeyKind kind;
  final bool isActive;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? semanticsLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppThemePalette.of(context);

    final background = backgroundColor ?? switch (kind) {
      KeyKind.operator => palette.operatorKey,
      KeyKind.equal => palette.equalKey,
      KeyKind.soft => palette.softKey,
      KeyKind.unit => isActive ? palette.unitKeyActive : palette.unitKey,
      KeyKind.normal => palette.normalKey,
    };
    final foreground = foregroundColor ?? switch (kind) {
      KeyKind.operator => palette.operatorKeyForeground,
      KeyKind.equal => palette.equalKeyForeground,
      KeyKind.soft => palette.softKeyForeground,
      KeyKind.unit => isActive
          ? palette.unitKeyActiveForeground
          : palette.unitKeyForeground,
      KeyKind.normal => palette.normalKeyForeground,
    };

    final effectiveLabel = semanticsLabel ?? label;

    return Padding(
      padding: const EdgeInsets.all(1.2),
      child: Semantics(
        button: true,
        label: effectiveLabel,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: background,
            foregroundColor: foreground,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            side: BorderSide(
              color: kind == KeyKind.unit
                  ? (isActive
                      ? palette.accent
                      : palette.unitBorder.withValues(alpha: 0.4))
                  : Colors.transparent,
              width: kind == KeyKind.unit ? (isActive ? 1.4 : 1.0) : 0.0,
            ),
            textStyle: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: onTap,
          child: icon == null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(label!),
                  ),
                )
              : Icon(icon),
        ),
      ),
    );
  }
}

