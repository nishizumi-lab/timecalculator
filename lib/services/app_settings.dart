import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme_palette.dart';

class AppSettings extends ChangeNotifier {
  static const _vibrationKey = 'vibration_enabled';
  static const _languageKey = 'app_language';
  static const _themeKey = 'app_theme';

  SharedPreferences? _prefs;

  bool _vibrationEnabled = true;
  bool get vibrationEnabled => _vibrationEnabled;

  String _languageCode = 'ja';
  AppLanguage get language => AppLanguage.fromCode(_languageCode);

  AppThemeType _themeType = AppThemeType.classicDark;
  AppThemeType get themeType => _themeType;
  AppThemePalette get palette => _themeType.palette;

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> load() async {
    final prefs = await _getPrefs();
    _vibrationEnabled = prefs.getBool(_vibrationKey) ?? true;
    _languageCode = prefs.getString(_languageKey) ?? 'ja';
    final savedTheme = prefs.getString(_themeKey);
    _themeType = AppThemeType.fromId(savedTheme);
    notifyListeners();
  }

  Future<void> setVibrationEnabled(bool value) async {
    _vibrationEnabled = value;
    final prefs = await _getPrefs();
    await prefs.setBool(_vibrationKey, value);
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    _languageCode = lang.code;
    final prefs = await _getPrefs();
    await prefs.setString(_languageKey, lang.code);
    notifyListeners();
  }

  Future<void> setThemeType(AppThemeType type) async {
    _themeType = type;
    final prefs = await _getPrefs();
    await prefs.setString(_themeKey, type.id);
    notifyListeners();
  }
}

