import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_strings.dart';
import '../services/app_settings.dart';
import '../theme/app_theme_palette.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.settings});

  final AppSettings settings;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _showLanguageDialog(BuildContext context, AppStrings strings) async {
    final palette = widget.settings.palette;
    final selectedLang = await showDialog<AppLanguage>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(strings.language),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppLanguage.values.map((lang) {
                final isSelected = widget.settings.language == lang;
                return ListTile(
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isSelected
                        ? palette.primary
                        : palette.textMuted.withValues(alpha: 0.5),
                  ),
                  title: Text(
                    lang.nativeName,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? palette.textPrimary : palette.textLight,
                    ),
                  ),
                  subtitle: lang != AppLanguage.system &&
                          lang != AppLanguage.japanese &&
                          lang != AppLanguage.english
                      ? Text(lang.englishName)
                      : null,
                  onTap: () => Navigator.of(ctx).pop(lang),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(strings.cancel),
            ),
          ],
        );
      },
    );

    if (selectedLang != null) {
      await widget.settings.setLanguage(selectedLang);
    }
  }

  Widget _buildThemeSectionHeader(String title, AppThemePalette palette) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: palette.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Future<void> _showThemeDialog(BuildContext context, AppStrings strings) async {
    final langCode = widget.settings.language.code;
    final darkThemes = AppThemeType.values.where((t) => !t.isLight).toList();
    final lightThemes = AppThemeType.values.where((t) => t.isLight).toList();

    final selectedTheme = await showDialog<AppThemeType>(
      context: context,
      builder: (ctx) {
        final currentPalette = widget.settings.palette;

        Widget buildThemeTile(AppThemeType type) {
          final isSelected = widget.settings.themeType == type;
          final palette = type.palette;
          return ListTile(
            dense: true,
            leading: Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected
                  ? currentPalette.primary
                  : currentPalette.textMuted.withValues(alpha: 0.5),
            ),
            title: Text(
              type.getLocalizedName(langCode),
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? currentPalette.textPrimary
                    : currentPalette.textLight,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final color in palette.previewChips)
                  Container(
                    width: 14,
                    height: 14,
                    margin: const EdgeInsets.only(left: 3),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: currentPalette.dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
              ],
            ),
            onTap: () => Navigator.of(ctx).pop(type),
          );
        }

        return AlertDialog(
          title: Text(strings.colorTheme),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildThemeSectionHeader(strings.darkThemes, currentPalette),
                ...darkThemes.map(buildThemeTile),
                Divider(color: currentPalette.dividerColor, height: 16),
                _buildThemeSectionHeader(strings.lightThemes, currentPalette),
                ...lightThemes.map(buildThemeTile),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(strings.cancel),
            ),
          ],
        );
      },
    );

    if (selectedTheme != null) {
      await widget.settings.setThemeType(selectedTheme);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settings,
      builder: (context, _) {
        final palette = AppThemePalette.of(context);
        final strings = AppStrings.of(context, widget.settings.language);
        final currentThemeName = widget.settings.themeType.getLocalizedName(
          widget.settings.language.code,
        );

        return Scaffold(
          appBar: AppBar(title: Text(strings.settings)),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
            children: [
              // 1. カラーテーマ設定
              Container(
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: palette.cardBorder),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.palette_outlined, color: palette.primary),
                    title: Text(strings.colorTheme),
                    subtitle: Text(currentThemeName),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final c in palette.previewChips)
                          Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.only(left: 3),
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: palette.dividerColor,
                                width: 1,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap: () => _showThemeDialog(context, strings),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // 2. 言語設定
              Container(
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: palette.cardBorder),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.language, color: palette.primary),
                    title: Text(strings.language),
                    subtitle: Text(widget.settings.language.nativeName),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showLanguageDialog(context, strings),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // 3. バイブレーション設定
              Container(
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: palette.cardBorder),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: SwitchListTile(
                    secondary: const Icon(Icons.vibration),
                    title: Text(strings.vibration),
                    subtitle: Text(strings.vibrationSubtitle),
                    value: widget.settings.vibrationEnabled,
                    activeTrackColor: palette.primary,
                    activeThumbColor: Colors.white,
                    onChanged: (val) {
                      widget.settings.setVibrationEnabled(val);
                      if (val) {
                        HapticFeedback.lightImpact();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

