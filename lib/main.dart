import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'services/app_settings.dart';
import 'services/history_storage.dart';

// 外部および既存テストとの互換性のための re-export
export 'app.dart';
export 'constants/app_colors.dart';
export 'constants/app_dimensions.dart';
export 'controllers/calculator_controller.dart';
export 'l10n/app_strings.dart';
export 'models/calculation_record.dart';
export 'models/calculator_state.dart';
export 'models/duration_unit.dart';
export 'models/expression_value.dart';
export 'parser/parser.dart';
export 'parser/parser_error.dart';
export 'parser/time_expression_parser.dart';
export 'parser/tokenizer.dart';
export 'screens/calculator_screen.dart';
export 'screens/conversion_screen.dart';
export 'screens/history_screen.dart';
export 'screens/settings_screen.dart';
export 'services/app_settings.dart';
export 'services/history_storage.dart';
export 'theme/app_theme.dart';
export 'theme/app_theme_palette.dart';
export 'utils/expression_span.dart';
export 'utils/time_formatter.dart';
export 'widgets/history_card.dart';
export 'widgets/keypad_button.dart';
export 'widgets/label_edit_dialog.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  final storage = HistoryStorage();
  await storage.load();
  final settings = AppSettings();
  await settings.load();
  runApp(TimeCalculatorApp(storage: storage, settings: settings));
}
