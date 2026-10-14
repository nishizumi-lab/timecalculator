import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_strings.dart';
import 'screens/calculator_screen.dart';
import 'services/app_settings.dart';
import 'services/history_storage.dart';
import 'theme/app_theme.dart';

class TimeCalculatorApp extends StatefulWidget {
  const TimeCalculatorApp({super.key, required this.storage, this.settings});

  final HistoryStorage storage;
  final AppSettings? settings;

  @override
  State<TimeCalculatorApp> createState() => _TimeCalculatorAppState();
}

class _TimeCalculatorAppState extends State<TimeCalculatorApp> {
  late final AppSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings ?? AppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settings,
      builder: (context, _) {
        final strings = AppStrings.get(_settings.language);
        final palette = _settings.palette;
        final isDark = palette.brightness == Brightness.dark;
        final appTheme = buildTheme(palette);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: strings.appTitle,
          locale: _settings.language.locale,
          supportedLocales: AppLanguage.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          theme: appTheme,
          darkTheme: appTheme,
          home: CalculatorScreen(
            storage: widget.storage,
            settings: _settings,
          ),
        );
      },
    );
  }
}
