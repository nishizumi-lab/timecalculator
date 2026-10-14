import 'package:flutter/material.dart';
import '../parser/parser_error.dart';

enum AppLanguage {
  system('system', '自動（端末の言語）', 'System Default'),
  japanese('ja', '日本語', 'Japanese'),
  english('en', 'English', 'English'),
  simplifiedChinese('zh', '简体中文', 'Simplified Chinese'),
  traditionalChinese('zh_Hant', '繁體中文', 'Traditional Chinese'),
  korean('ko', '한국어', 'Korean'),
  spanish('es', 'Español', 'Spanish'),
  french('fr', 'Français', 'French'),
  german('de', 'Deutsch', 'German'),
  italian('it', 'Italiano', 'Italian'),
  portuguese('pt', 'Português', 'Portuguese'),
  russian('ru', 'Русский', 'Russian'),
  hindi('hi', 'हिन्दी', 'Hindi'),
  arabic('ar', 'العربية', 'Arabic'),
  indonesian('id', 'Bahasa Indonesia', 'Indonesian'),
  vietnamese('vi', 'Tiếng Việt', 'Vietnamese'),
  thai('th', 'ภาษาไทย', 'Thai'),
  turkish('tr', 'Türkçe', 'Turkish'),
  dutch('nl', 'Nederlands', 'Dutch'),
  polish('pl', 'Polski', 'Polish'),
  bengali('bn', 'বাংলা', 'Bengali'),
  malay('ms', 'Bahasa Melayu', 'Malay'),
  filipino('fil', 'Filipino', 'Filipino'),
  swedish('sv', 'Svenska', 'Swedish'),
  norwegian('no', 'Norsk', 'Norwegian'),
  ukrainian('uk', 'Українська', 'Ukrainian'),
  danish('da', 'Dansk', 'Danish'),
  finnish('fi', 'Suomi', 'Finnish'),
  czech('cs', 'Čeština', 'Czech'),
  greek('el', 'Ελληνικά', 'Greek'),
  romanian('ro', 'Română', 'Romanian'),
  hungarian('hu', 'Magyar', 'Hungarian');

  const AppLanguage(this.code, this.nativeName, this.englishName);
  final String code;
  final String nativeName;
  final String englishName;

  static AppLanguage fromCode(String? code) {
    if (code == null || code.isEmpty || code == 'system') {
      return AppLanguage.system;
    }
    return AppLanguage.values.firstWhere(
      (e) => e.code == code,
      orElse: () => AppLanguage.system,
    );
  }

  Locale? get locale {
    if (this == AppLanguage.system) return null;
    if (code == 'zh_Hant') return const Locale('zh', 'Hant');
    return Locale(code);
  }

  static List<Locale> get supportedLocales {
    return values
        .where((lang) => lang != AppLanguage.system)
        .map((lang) => lang.locale!)
        .toList();
  }
}

class UnitLabels {
  const UnitLabels({
    required this.year,
    required this.month,
    required this.week,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
    this.separator = '',
  });

  final String year;
  final String month;
  final String week;
  final String day;
  final String hour;
  final String minute;
  final String second;
  final String separator;
}

class AppStrings {
  const AppStrings({
    required this.appTitle,
    required this.units,
    required this.history,
    required this.historyEmpty,
    required this.totalDurationHeader,
    required this.itemCountSuffix,
    required this.copyAllHistory,
    required this.clearAllHistory,
    required this.clearAllConfirmTitle,
    required this.clearAllConfirmMessage,
    required this.delete,
    required this.cancel,
    required this.save,
    required this.copiedHistoryToast,
    required this.copiedResultToast,
    required this.copiedConversionToast,
    required this.settings,
    required this.language,
    required this.vibration,
    required this.vibrationSubtitle,
    required this.appearance,
    required this.darkModeOnly,
    this.colorTheme = 'Color Theme',
    this.darkThemes = 'Dark Themes',
    this.lightThemes = 'Light Themes',
    required this.editLabel,
    required this.labelHint,
    required this.conversionsTitle,
    required this.today,
    required this.yesterday,
    required this.share,
    required this.sharePrefix,
  });

  final String appTitle;
  final UnitLabels units;
  final String history;
  final String historyEmpty;
  final String totalDurationHeader;
  final String itemCountSuffix;
  final String copyAllHistory;
  final String clearAllHistory;
  final String clearAllConfirmTitle;
  final String clearAllConfirmMessage;
  final String delete;
  final String cancel;
  final String save;
  final String copiedHistoryToast;
  final String Function(String) copiedResultToast;
  final String Function(String) copiedConversionToast;
  final String settings;
  final String language;
  final String vibration;
  final String vibrationSubtitle;
  final String appearance;
  final String darkModeOnly;
  final String colorTheme;
  final String darkThemes;
  final String lightThemes;
  final String editLabel;
  final String labelHint;
  final String conversionsTitle;
  final String today;
  final String yesterday;
  final String share;
  final String sharePrefix;

  String formatParserError(ParserErrorCode code, [String? param]) {
    if (this == _ja) {
      switch (code) {
        case ParserErrorCode.unexpectedEnd:
          return '式の末尾を解釈できません';
        case ParserErrorCode.invalidNumber:
          return '数値を解釈できません';
        case ParserErrorCode.missingMinuteAfterColon:
          return 'コロンの後に分を入力してください';
        case ParserErrorCode.invalidMinuteNumber:
          return '分の数値を解釈できません';
        case ParserErrorCode.missingSecondAfterColon:
          return 'コロンの後に秒を入力してください';
        case ParserErrorCode.invalidSecondNumber:
          return '秒の数値を解釈できません';
        case ParserErrorCode.unsupportedUnit:
          return '未対応の単位です';
        case ParserErrorCode.missingClosingParen:
          return '閉じ括弧が必要です';
        case ParserErrorCode.invalidExpressionStart:
          return '数値または括弧から式を開始してください';
        case ParserErrorCode.multiplyDurationsNotSupported:
          return '時間どうしの掛け算には対応していません';
        case ParserErrorCode.divisionByZero:
          return '0では割れません';
        case ParserErrorCode.unsupportedOperator:
          return '未対応の演算子です';
        case ParserErrorCode.unsupportedChar:
          return param != null ? '未対応の文字です: $param' : '未対応の文字です';
        case ParserErrorCode.generalError:
          return '式を計算できません';
      }
    } else if (this == _zh || this == _zhHant) {
      switch (code) {
        case ParserErrorCode.unexpectedEnd:
          return '无法解析表达式末尾';
        case ParserErrorCode.invalidNumber:
          return '无效的数值';
        case ParserErrorCode.missingMinuteAfterColon:
          return '请在冒号后输入分钟';
        case ParserErrorCode.invalidMinuteNumber:
          return '无效的分钟数值';
        case ParserErrorCode.missingSecondAfterColon:
          return '请在冒号后输入秒';
        case ParserErrorCode.invalidSecondNumber:
          return '无效的秒数值';
        case ParserErrorCode.unsupportedUnit:
          return '不支持的单位';
        case ParserErrorCode.missingClosingParen:
          return '缺少右括号';
        case ParserErrorCode.invalidExpressionStart:
          return '请以数字或括号开头';
        case ParserErrorCode.multiplyDurationsNotSupported:
          return '不支持时间之间的乘法';
        case ParserErrorCode.divisionByZero:
          return '不能除以0';
        case ParserErrorCode.unsupportedOperator:
          return '不支持的运算符';
        case ParserErrorCode.unsupportedChar:
          return param != null ? '不支持的字符: $param' : '不支持的字符';
        case ParserErrorCode.generalError:
          return '无法计算表达式';
      }
    } else if (this == _ko) {
      switch (code) {
        case ParserErrorCode.unexpectedEnd:
          return '수식의 끝을 해석할 수 없습니다';
        case ParserErrorCode.invalidNumber:
          return '올바르지 않은 숫자입니다';
        case ParserErrorCode.missingMinuteAfterColon:
          return '콜론 뒤에 분을 입력하세요';
        case ParserErrorCode.invalidMinuteNumber:
          return '올바르지 않은 분 값입니다';
        case ParserErrorCode.missingSecondAfterColon:
          return '콜론 뒤에 초를 입력하세요';
        case ParserErrorCode.invalidSecondNumber:
          return '올바르지 않은 초 값입니다';
        case ParserErrorCode.unsupportedUnit:
          return '지원하지 않는 단위입니다';
        case ParserErrorCode.missingClosingParen:
          return '닫는 괄호가 필요합니다';
        case ParserErrorCode.invalidExpressionStart:
          return '숫자나 괄호로 시작하세요';
        case ParserErrorCode.multiplyDurationsNotSupported:
          return '시간 단위 간의 곱셈은 지원하지 않습니다';
        case ParserErrorCode.divisionByZero:
          return '0으로 나눌 수 없습니다';
        case ParserErrorCode.unsupportedOperator:
          return '지원하지 않는 연산자입니다';
        case ParserErrorCode.unsupportedChar:
          return param != null ? '지원하지 않는 문자입니다: $param' : '지원하지 않는 문자입니다';
        case ParserErrorCode.generalError:
          return '수식을 계산할 수 없습니다';
      }
    } else if (this == _es) {
      switch (code) {
        case ParserErrorCode.unexpectedEnd:
          return 'No se puede analizar el final de la expresión';
        case ParserErrorCode.invalidNumber:
          return 'Número inválido';
        case ParserErrorCode.missingMinuteAfterColon:
          return 'Ingrese los minutos después de dos puntos';
        case ParserErrorCode.invalidMinuteNumber:
          return 'Valor de minutos inválido';
        case ParserErrorCode.missingSecondAfterColon:
          return 'Ingrese los segundos después de dos puntos';
        case ParserErrorCode.invalidSecondNumber:
          return 'Valor de segundos inválido';
        case ParserErrorCode.unsupportedUnit:
          return 'Unidad no compatible';
        case ParserErrorCode.missingClosingParen:
          return 'Falta el paréntesis de cierre';
        case ParserErrorCode.invalidExpressionStart:
          return 'Comience con un número o paréntesis';
        case ParserErrorCode.multiplyDurationsNotSupported:
          return 'No se admite multiplicar dos duraciones';
        case ParserErrorCode.divisionByZero:
          return 'No se puede dividir por cero';
        case ParserErrorCode.unsupportedOperator:
          return 'Operador no compatible';
        case ParserErrorCode.unsupportedChar:
          return param != null ? 'Carácter no compatible: $param' : 'Carácter no compatible';
        case ParserErrorCode.generalError:
          return 'No se puede calcular la expresión';
      }
    }

    // Default English fallback
    switch (code) {
      case ParserErrorCode.unexpectedEnd:
        return 'Cannot parse end of expression';
      case ParserErrorCode.invalidNumber:
        return 'Invalid number';
      case ParserErrorCode.missingMinuteAfterColon:
        return 'Enter minutes after colon';
      case ParserErrorCode.invalidMinuteNumber:
        return 'Invalid minute value';
      case ParserErrorCode.missingSecondAfterColon:
        return 'Enter seconds after colon';
      case ParserErrorCode.invalidSecondNumber:
        return 'Invalid second value';
      case ParserErrorCode.unsupportedUnit:
        return 'Unsupported unit';
      case ParserErrorCode.missingClosingParen:
        return 'Missing closing parenthesis';
      case ParserErrorCode.invalidExpressionStart:
        return 'Start with a number or parenthesis';
      case ParserErrorCode.multiplyDurationsNotSupported:
        return 'Multiplying two durations is not supported';
      case ParserErrorCode.divisionByZero:
        return 'Cannot divide by zero';
      case ParserErrorCode.unsupportedOperator:
        return 'Unsupported operator';
      case ParserErrorCode.unsupportedChar:
        return param != null ? 'Unsupported character: $param' : 'Unsupported character';
      case ParserErrorCode.generalError:
        return 'Cannot calculate expression';
    }
  }

  String semanticsKeypad(String key) {
    if (this == _ja) {
      switch (key) {
        case 'backspace':
          return '1文字削除';
        case 'C':
          return 'クリア';
        case 'paren':
          return '括弧';
        case ':':
          return 'コロン';
        case '÷':
          return '割る';
        case '×':
          return '掛ける';
        case '−':
        case '-':
          return '引く';
        case '+':
          return '足す';
        case '.':
          return '小数点';
        case '=':
          return '計算実行';
      }
    } else if (this == _zh || this == _zhHant) {
      switch (key) {
        case 'backspace':
          return '删除单个字符';
        case 'C':
          return '清除';
        case 'paren':
          return '括号';
        case ':':
          return '冒号';
        case '÷':
          return '除以';
        case '×':
          return '乘以';
        case '−':
        case '-':
          return '减去';
        case '+':
          return '加上';
        case '.':
          return '小数点';
        case '=':
          return '计算';
      }
    }
    switch (key) {
      case 'backspace':
        return 'Backspace';
      case 'C':
        return 'Clear';
      case 'paren':
        return 'Parentheses';
      case ':':
        return 'Colon';
      case '÷':
        return 'Divide';
      case '×':
        return 'Multiply';
      case '−':
      case '-':
        return 'Minus';
      case '+':
        return 'Plus';
      case '.':
        return 'Decimal point';
      case '=':
        return 'Calculate';
    }
    return key;
  }

  static AppStrings of(BuildContext context, [AppLanguage? language]) {
    final lang = language ?? AppLanguage.japanese;
    return get(lang, Localizations.maybeLocaleOf(context));
  }

  static AppStrings get(AppLanguage lang, [Locale? systemLocale]) {
    var effectiveCode = lang.code;
    if (lang == AppLanguage.system) {
      final code = systemLocale?.languageCode ?? 'ja';
      final script = systemLocale?.scriptCode;
      if (code == 'zh') {
        effectiveCode = (script == 'Hant' ||
                systemLocale?.countryCode == 'TW' ||
                systemLocale?.countryCode == 'HK')
            ? 'zh_Hant'
            : 'zh';
      } else {
        effectiveCode = code;
      }
    }

    switch (effectiveCode) {
      case 'en':
        return _en;
      case 'zh':
        return _zh;
      case 'zh_Hant':
        return _zhHant;
      case 'ko':
        return _ko;
      case 'es':
        return _es;
      case 'fr':
        return _fr;
      case 'de':
        return _de;
      case 'it':
        return _it;
      case 'pt':
        return _pt;
      case 'ru':
        return _ru;
      case 'hi':
        return _hi;
      case 'ar':
        return _ar;
      case 'id':
        return _id;
      case 'vi':
        return _vi;
      case 'th':
        return _th;
      case 'tr':
        return _tr;
      case 'nl':
        return _nl;
      case 'pl':
        return _pl;
      case 'bn':
        return _bn;
      case 'ms':
        return _ms;
      case 'fil':
      case 'tl':
        return _fil;
      case 'sv':
        return _sv;
      case 'no':
      case 'nb':
      case 'nn':
        return _no;
      case 'uk':
        return _uk;
      case 'da':
        return _da;
      case 'fi':
        return _fi;
      case 'cs':
        return _cs;
      case 'el':
        return _el;
      case 'ro':
        return _ro;
      case 'hu':
        return _hu;
      case 'ja':
      default:
        return _ja;
    }
  }

  // 1. 日本語 (Japanese)
  static const _ja = AppStrings(
    appTitle: '時間計算機',
    units: UnitLabels(year: '年', month: '月', week: '週', day: '日', hour: '時間', minute: '分', second: '秒'),
    history: '履歴',
    historyEmpty: '履歴がありません',
    totalDurationHeader: '全履歴の合計時間',
    itemCountSuffix: '件',
    copyAllHistory: '全履歴をコピー',
    clearAllHistory: '履歴を全削除',
    clearAllConfirmTitle: '履歴の全削除',
    clearAllConfirmMessage: 'すべての計算履歴を削除してもよろしいですか？',
    delete: '削除',
    cancel: 'キャンセル',
    save: '保存する',
    copiedHistoryToast: '全履歴をクリップボードにコピーしました',
    copiedResultToast: _copiedResultJa,
    copiedConversionToast: _copiedConversionJa,
    settings: '設定',
    language: '言語',
    vibration: 'キー入力の振動',
    vibrationSubtitle: 'ボタンタップ時に軽く振動します',
    appearance: '外観',
    darkModeOnly: 'ダークモード（固定）',
    colorTheme: 'カラーテーマ',
    darkThemes: 'ダークテーマ',
    lightThemes: 'ライトテーマ',
    editLabel: 'ラベルの編集',
    labelHint: '例: 作業時間・プロジェクトA',
    conversionsTitle: '単位換算',
    today: '今日',
    yesterday: '昨日',
    share: '共有',
    sharePrefix: '【時間計算機】',
  );
  static String _copiedResultJa(String r) => '計算結果「$r」をコピーしました';
  static String _copiedConversionJa(String c) => '換算値「$c」をコピーしました';

  // 2. English (英語)
  static const _en = AppStrings(
    appTitle: 'Time Calculator',
    units: UnitLabels(year: 'yr', month: 'mo', week: 'wk', day: 'd', hour: 'hr', minute: 'min', second: 'sec', separator: ' '),
    history: 'History',
    historyEmpty: 'No history yet',
    totalDurationHeader: 'Total Duration of All Records',
    itemCountSuffix: 'items',
    copyAllHistory: 'Copy All History',
    clearAllHistory: 'Clear All History',
    clearAllConfirmTitle: 'Clear History',
    clearAllConfirmMessage: 'Are you sure you want to delete all calculation records?',
    delete: 'Delete',
    cancel: 'Cancel',
    save: 'Save',
    copiedHistoryToast: 'All history copied to clipboard',
    copiedResultToast: _copiedResultEn,
    copiedConversionToast: _copiedConversionEn,
    settings: 'Settings',
    language: 'Language',
    vibration: 'Keypad Haptic Feedback',
    vibrationSubtitle: 'Vibrate slightly when buttons are pressed',
    appearance: 'Appearance',
    darkModeOnly: 'Dark Mode (Always)',
    colorTheme: 'Color Theme',
    darkThemes: 'Dark Themes',
    lightThemes: 'Light Themes',
    editLabel: 'Edit Label',
    labelHint: 'e.g., Work hours / Task A',
    conversionsTitle: 'Conversions',
    today: 'Today',
    yesterday: 'Yesterday',
    share: 'Share',
    sharePrefix: '[Time Calculator]',
  );
  static String _copiedResultEn(String r) => 'Copied result: $r';
  static String _copiedConversionEn(String c) => 'Copied conversion: $c';

  // 3. 简体中文 (Simplified Chinese)
  static const _zh = AppStrings(
    appTitle: '时间计算器',
    units: UnitLabels(year: '年', month: '月', week: '周', day: '天', hour: '时', minute: '分', second: '秒'),
    history: '历史记录',
    historyEmpty: '暂无历史记录',
    totalDurationHeader: '所有记录的总时长',
    itemCountSuffix: '条',
    copyAllHistory: '复制所有历史',
    clearAllHistory: '清除所有历史',
    clearAllConfirmTitle: '清除历史记录',
    clearAllConfirmMessage: '确定要删除所有计算历史记录吗？',
    delete: '删除',
    cancel: '取消',
    save: '保存',
    copiedHistoryToast: '所有历史记录已复制到剪贴板',
    copiedResultToast: _copiedResultZh,
    copiedConversionToast: _copiedConversionZh,
    settings: '设置',
    language: '语言',
    vibration: '按键震动',
    vibrationSubtitle: '按键时提供轻微触觉反馈',
    appearance: '外观',
    darkModeOnly: '深色模式（固定）',
    colorTheme: '颜色主题',
    darkThemes: '深色主题',
    lightThemes: '浅色主题',
    editLabel: '编辑标签',
    labelHint: '例如：工作时间 / 任务A',
    conversionsTitle: '单位换算',
    today: '今天',
    yesterday: '昨天',
    share: '分享',
    sharePrefix: '【时间计算器】',
  );
  static String _copiedResultZh(String r) => '已复制计算结果：$r';
  static String _copiedConversionZh(String c) => '已复制换算值：$c';

  // 4. 繁體中文 (Traditional Chinese)
  static const _zhHant = AppStrings(
    appTitle: '時間計算器',
    units: UnitLabels(year: '年', month: '月', week: '週', day: '天', hour: '時', minute: '分', second: '秒'),
    history: '歷史記錄',
    historyEmpty: '尚無歷史記錄',
    totalDurationHeader: '所有記錄的總時長',
    itemCountSuffix: '筆',
    copyAllHistory: '複製所有歷史',
    clearAllHistory: '清除所有歷史',
    clearAllConfirmTitle: '清除歷史記錄',
    clearAllConfirmMessage: '確定要刪除所有計算歷史記錄嗎？',
    delete: '刪除',
    cancel: '取消',
    save: '儲存',
    copiedHistoryToast: '所有歷史記錄已複製到剪貼簿',
    copiedResultToast: _copiedResultZhHant,
    copiedConversionToast: _copiedConversionZhHant,
    settings: '設定',
    language: '語言',
    vibration: '按鍵震動',
    vibrationSubtitle: '按鍵時提供輕微觸覺回饋',
    appearance: '外觀',
    darkModeOnly: '深色模式（固定）',
    colorTheme: '色彩主題',
    darkThemes: '深色主題',
    lightThemes: '淺色主題',
    editLabel: '編輯標籤',
    labelHint: '例如：工作時間 / 任務A',
    conversionsTitle: '單位換算',
    today: '今天',
    yesterday: '昨天',
    share: '分享',
    sharePrefix: '【時間計算器】',
  );
  static String _copiedResultZhHant(String r) => '已複製計算結果：$r';
  static String _copiedConversionZhHant(String c) => '已複製換算值：$c';

  // 5. 한국어 (Korean)
  static const _ko = AppStrings(
    appTitle: '시간 계산기',
    units: UnitLabels(year: '년', month: '월', week: '주', day: '일', hour: '시간', minute: '분', second: '초'),
    history: '기록',
    historyEmpty: '계산 기록이 없습니다',
    totalDurationHeader: '모든 기록의 총 시간',
    itemCountSuffix: '건',
    copyAllHistory: '전체 기록 복사',
    clearAllHistory: '전체 기록 삭제',
    clearAllConfirmTitle: '기록 삭제',
    clearAllConfirmMessage: '모든 계산 기록을 삭제하시겠습니까?',
    delete: '삭제',
    cancel: '취소',
    save: '저장',
    copiedHistoryToast: '전체 기록이 클립보드에 복사되었습니다',
    copiedResultToast: _copiedResultKo,
    copiedConversionToast: _copiedConversionKo,
    settings: '설정',
    language: '언어',
    vibration: '키패드 진동',
    vibrationSubtitle: '버튼 터치 시 가볍게 진동합니다',
    appearance: '화면 테마',
    darkModeOnly: '다克 모드 (고정)',
    colorTheme: '컬러 테마',
    darkThemes: '다크 테마',
    lightThemes: '라이트 테마',
    editLabel: '라벨 수정',
    labelHint: '예: 근무 시간 / 작업 A',
    conversionsTitle: '단위 변환',
    today: '오늘',
    yesterday: '어제',
    share: '공유',
    sharePrefix: '[시간 계산기]',
  );
  static String _copiedResultKo(String r) => '계산 결과가 복사되었습니다: $r';
  static String _copiedConversionKo(String c) => '변환 값이 복사되었습니다: $c';

  // 6. Español (スペイン語)
  static const _es = AppStrings(
    appTitle: 'Calculadora de Tiempo',
    units: UnitLabels(year: 'año', month: 'mes', week: 'sem', day: 'd', hour: 'h', minute: 'min', second: 's', separator: ' '),
    history: 'Historial',
    historyEmpty: 'No hay historial',
    totalDurationHeader: 'Duración total de todos los registros',
    itemCountSuffix: 'elementos',
    copyAllHistory: 'Copiar todo el historial',
    clearAllHistory: 'Borrar todo el historial',
    clearAllConfirmTitle: 'Borrar historial',
    clearAllConfirmMessage: '¿Está seguro de que desea eliminar todos los registros de cálculo?',
    delete: 'Eliminar',
    cancel: 'Cancelar',
    save: 'Guardar',
    copiedHistoryToast: 'Todo el historial copiado al portapapeles',
    copiedResultToast: _copiedResultEs,
    copiedConversionToast: _copiedConversionEs,
    settings: 'Ajustes',
    language: 'Idioma',
    vibration: 'Vibración del teclado',
    vibrationSubtitle: 'Vibrar ligeramente al presionar los botones',
    appearance: 'Apariencia',
    darkModeOnly: 'Modo oscuro (fijo)',
    colorTheme: 'Tema de Color',
    darkThemes: 'Temas Oscuros',
    lightThemes: 'Temas Claros',
    editLabel: 'Editar etiqueta',
    labelHint: 'Ej: Horas de trabajo / Tarea A',
    conversionsTitle: 'Conversiones',
    today: 'Hoy',
    yesterday: 'Ayer',
    share: 'Compartir',
    sharePrefix: '[Calculadora de Tiempo]',
  );
  static String _copiedResultEs(String r) => 'Resultado copiado: $r';
  static String _copiedConversionEs(String c) => 'Conversión copiada: $c';

  // 7. Français (フランス語)
  static const _fr = AppStrings(
    appTitle: 'Calculateur de Temps',
    units: UnitLabels(year: 'an', month: 'mois', week: 'sem', day: 'j', hour: 'h', minute: 'min', second: 's', separator: ' '),
    history: 'Historique',
    historyEmpty: 'Aucun historique',
    totalDurationHeader: 'Durée totale de tous les enregistrements',
    itemCountSuffix: 'éléments',
    copyAllHistory: 'Copier tout l\'historique',
    clearAllHistory: 'Effacer tout l\'historique',
    clearAllConfirmTitle: 'Effacer l\'historique',
    clearAllConfirmMessage: 'Êtes-vous sûr de vouloir supprimer tout l\'historique des calculs ?',
    delete: 'Supprimer',
    cancel: 'Annuler',
    save: 'Enregistrer',
    copiedHistoryToast: 'Tout l\'historique a été copié dans le presse-papiers',
    copiedResultToast: _copiedResultFr,
    copiedConversionToast: _copiedConversionFr,
    settings: 'Paramètres',
    language: 'Langue',
    vibration: 'Vibration des touches',
    vibrationSubtitle: 'Vibrer légèrement lors de l\'appui sur les touches',
    appearance: 'Apparence',
    darkModeOnly: 'Mode sombre (fixe)',
    editLabel: 'Modifier l\'étiquette',
    labelHint: 'Ex: Heures de travail / Tâche A',
    conversionsTitle: 'Conversions',
    today: 'Aujourd\'hui',
    yesterday: 'Hier',
    share: 'Partager',
    sharePrefix: '[Calculateur de Temps]',
  );
  static String _copiedResultFr(String r) => 'Résultat copié: $r';
  static String _copiedConversionFr(String c) => 'Conversion copiée: $c';

  // 8. Deutsch (ドイツ語)
  static const _de = AppStrings(
    appTitle: 'Zeitrechner',
    units: UnitLabels(year: 'J', month: 'M', week: 'W', day: 'T', hour: 'Std', minute: 'Min', second: 'Sek', separator: ' '),
    history: 'Verlauf',
    historyEmpty: 'Noch kein Verlauf',
    totalDurationHeader: 'Gesamtdauer aller Einträge',
    itemCountSuffix: 'Einträge',
    copyAllHistory: 'Gesamten Verlauf kopieren',
    clearAllHistory: 'Gesamten Verlauf löschen',
    clearAllConfirmTitle: 'Verlauf löschen',
    clearAllConfirmMessage: 'Möchten Sie wirklich alle Berechnungseinträge löschen?',
    delete: 'Löschen',
    cancel: 'Abbrechen',
    save: 'Speichern',
    copiedHistoryToast: 'Gesamter Verlauf in die Zwischenablage kopiert',
    copiedResultToast: _copiedResultDe,
    copiedConversionToast: _copiedConversionDe,
    settings: 'Einstellungen',
    language: 'Sprache',
    vibration: 'Tastatur-Vibration',
    vibrationSubtitle: 'Beim Antippen von Tasten leicht vibrieren',
    appearance: 'Erscheinungsbild',
    darkModeOnly: 'Dunkelmodus (dauerhaft)',
    editLabel: 'Bezeichnung bearbeiten',
    labelHint: 'z.B. Arbeitszeit / Aufgabe A',
    conversionsTitle: 'Umrechnungen',
    today: 'Heute',
    yesterday: 'Gestern',
    share: 'Teilen',
    sharePrefix: '[Zeitrechner]',
  );
  static String _copiedResultDe(String r) => 'Ergebnis kopiert: $r';
  static String _copiedConversionDe(String c) => 'Umrechnung kopiert: $c';

  // 9. Italiano (イタリア語)
  static const _it = AppStrings(
    appTitle: 'Calcolatrice Oraria',
    units: UnitLabels(year: 'anno', month: 'mese', week: 'sett', day: 'g', hour: 'ora', minute: 'min', second: 'sec', separator: ' '),
    history: 'Cronologia',
    historyEmpty: 'Nessuna cronologia',
    totalDurationHeader: 'Durata totale di tutti i record',
    itemCountSuffix: 'elementi',
    copyAllHistory: 'Copia tutto',
    clearAllHistory: 'Cancella tutto',
    clearAllConfirmTitle: 'Cancella cronologia',
    clearAllConfirmMessage: 'Sei sicuro di voler eliminare tutta la cronologia dei calcoli?',
    delete: 'Elimina',
    cancel: 'Annulla',
    save: 'Salva',
    copiedHistoryToast: 'Cronologia copiata negli appunti',
    copiedResultToast: _copiedResultIt,
    copiedConversionToast: _copiedConversionIt,
    settings: 'Impostazioni',
    language: 'Lingua',
    vibration: 'Vibrazione tastiera',
    vibrationSubtitle: 'Vibra leggermente quando si premono i pulsanti',
    appearance: 'Aspetto',
    darkModeOnly: 'Modalità scura (fissa)',
    editLabel: 'Modifica etichetta',
    labelHint: 'Es. Orario di lavoro / Attività A',
    conversionsTitle: 'Conversioni',
    today: 'Oggi',
    yesterday: 'Ieri',
    share: 'Condividi',
    sharePrefix: '[Calcolatrice Oraria]',
  );
  static String _copiedResultIt(String r) => 'Risultato copiato: $r';
  static String _copiedConversionIt(String c) => 'Conversione copiata: $c';

  // 10. Português (ポルトガル語)
  static const _pt = AppStrings(
    appTitle: 'Calculadora de Tempo',
    units: UnitLabels(year: 'ano', month: 'mês', week: 'sem', day: 'd', hour: 'h', minute: 'min', second: 's', separator: ' '),
    history: 'Histórico',
    historyEmpty: 'Nenhum histórico',
    totalDurationHeader: 'Duração total de todos os registros',
    itemCountSuffix: 'itens',
    copyAllHistory: 'Copiar tudo',
    clearAllHistory: 'Limpar tudo',
    clearAllConfirmTitle: 'Limpar histórico',
    clearAllConfirmMessage: 'Tem certeza de que deseja apagar todo o histórico de cálculos?',
    delete: 'Excluir',
    cancel: 'Cancelar',
    save: 'Salvar',
    copiedHistoryToast: 'Histórico copiado para a área de transferência',
    copiedResultToast: _copiedResultPt,
    copiedConversionToast: _copiedConversionPt,
    settings: 'Configurações',
    language: 'Idioma',
    vibration: 'Vibração do teclado',
    vibrationSubtitle: 'Vibra levemente ao tocar nos botões',
    appearance: 'Aparência',
    darkModeOnly: 'Modo escuro (fixo)',
    editLabel: 'Editar etiqueta',
    labelHint: 'Ex: Horas de trabalho / Tarefa A',
    conversionsTitle: 'Conversões',
    today: 'Hoje',
    yesterday: 'Ontem',
    share: 'Compartilhar',
    sharePrefix: '[Calculadora de Tempo]',
  );
  static String _copiedResultPt(String r) => 'Resultado copiado: $r';
  static String _copiedConversionPt(String c) => 'Conversão copiada: $c';

  // 11. Русский (ロシア語)
  static const _ru = AppStrings(
    appTitle: 'Калькулятор Времени',
    units: UnitLabels(year: 'г', month: 'мес', week: 'нед', day: 'д', hour: 'ч', minute: 'мин', second: 'сек'),
    history: 'История',
    historyEmpty: 'История пуста',
    totalDurationHeader: 'Общая продолжительность всех записей',
    itemCountSuffix: 'записей',
    copyAllHistory: 'Копировать все',
    clearAllHistory: 'Очистить все',
    clearAllConfirmTitle: 'Очистить историю',
    clearAllConfirmMessage: 'Вы уверены, что хотите удалить всю историю вычислений?',
    delete: 'Удалить',
    cancel: 'Отмена',
    save: 'Сохранить',
    copiedHistoryToast: 'История скопирована в буфер обмена',
    copiedResultToast: _copiedResultRu,
    copiedConversionToast: _copiedConversionRu,
    settings: 'Настройки',
    language: 'Язык',
    vibration: 'Вибрация клавиш',
    vibrationSubtitle: 'Легкая вибрация при нажатии кнопок',
    appearance: 'Внешний вид',
    darkModeOnly: 'Темная тема (всегда)',
    editLabel: 'Изменить метку',
    labelHint: 'Например: Рабочие часы / Задача А',
    conversionsTitle: 'Перевод единиц',
    today: 'Сегодня',
    yesterday: 'Вчера',
    share: 'Поделиться',
    sharePrefix: '[Калькулятор Времени]',
  );
  static String _copiedResultRu(String r) => 'Скопировано: $r';
  static String _copiedConversionRu(String c) => 'Перевод скопирован: $c';

  // 12. हिन्दी (ヒンディー語)
  static const _hi = AppStrings(
    appTitle: 'समय कैलकुलेटर',
    units: UnitLabels(year: 'वर्ष', month: 'माह', week: 'सप्ताह', day: 'दिन', hour: 'घंटे', minute: 'मिनट', second: 'सेकंड'),
    history: 'इतिहास',
    historyEmpty: 'कोई इतिहास नहीं',
    totalDurationHeader: 'सभी रिकॉर्ड की कुल अवधि',
    itemCountSuffix: 'प्रविष्टियां',
    copyAllHistory: 'सभी कॉपी करें',
    clearAllHistory: 'सभी साफ़ करें',
    clearAllConfirmTitle: 'इतिहास साफ़ करें',
    clearAllConfirmMessage: 'क्या आप वाकई गणना इतिहास हटाना चाहते हैं?',
    delete: 'हटाएं',
    cancel: 'रद्द करें',
    save: 'सहेजें',
    copiedHistoryToast: 'इतिहास क्लिपबोर्ड पर कॉपी किया गया',
    copiedResultToast: _copiedResultHi,
    copiedConversionToast: _copiedConversionHi,
    settings: 'सेटिंग्स',
    language: 'भाषा',
    vibration: 'कीपैड कंपन',
    vibrationSubtitle: 'बटन दबाने पर हल्का कंपन',
    appearance: 'उपस्थिति',
    darkModeOnly: 'डार्क मोड (स्थिर)',
    editLabel: 'लेबल संपादित करें',
    labelHint: 'जैसे: कार्य के घंटे / कार्य A',
    conversionsTitle: 'रूपांतरण',
    today: 'आज',
    yesterday: 'कल',
    share: 'साझा करें',
    sharePrefix: '[समय कैलकुलेटर]',
  );
  static String _copiedResultHi(String r) => 'कॉपी किया गया: $r';
  static String _copiedConversionHi(String c) => 'रूपांतरण कॉपी किया गया: $c';

  // 13. العربية (アラビア語)
  static const _ar = AppStrings(
    appTitle: 'حاسبة الوقت',
    units: UnitLabels(year: 'سنة', month: 'شهر', week: 'أسبوع', day: 'يوم', hour: 'ساعة', minute: 'دقيقة', second: 'ثانية'),
    history: 'السجل',
    historyEmpty: 'لا يوجد سجل',
    totalDurationHeader: 'إجمالي مدة جميع السجلات',
    itemCountSuffix: 'عناصر',
    copyAllHistory: 'نسخ الكل',
    clearAllHistory: 'مسح الكل',
    clearAllConfirmTitle: 'مسح السجل',
    clearAllConfirmMessage: 'هل أنت متأكد من رغبتك في حذف جميع السجلات؟',
    delete: 'حذف',
    cancel: 'إلغاء',
    save: 'حفظ',
    copiedHistoryToast: 'تم نسخ السجل إلى الحافظة',
    copiedResultToast: _copiedResultAr,
    copiedConversionToast: _copiedConversionAr,
    settings: 'الإعدادات',
    language: 'اللغة',
    vibration: 'اهتزاز المفاتيح',
    vibrationSubtitle: 'اهتزاز خفيف عند الضغط على الأزرار',
    appearance: 'المظهر',
    darkModeOnly: 'الوضع الداكن (دائم)',
    editLabel: 'تعديل التسمية',
    labelHint: 'مثال: ساعات العمل / المهمة أ',
    conversionsTitle: 'التحويلات',
    today: 'اليوم',
    yesterday: 'أمس',
    share: 'مشاركة',
    sharePrefix: '[حاسبة الوقت]',
  );
  static String _copiedResultAr(String r) => 'تم النسخ: $r';
  static String _copiedConversionAr(String c) => 'تم نسخ التحويل: $c';

  // 14. Bahasa Indonesia (インドネシア語)
  static const _id = AppStrings(
    appTitle: 'Kalkulator Waktu',
    units: UnitLabels(year: 'thn', month: 'bln', week: 'mgg', day: 'hari', hour: 'jam', minute: 'mnt', second: 'dtk'),
    history: 'Riwayat',
    historyEmpty: 'Belum ada riwayat',
    totalDurationHeader: 'Total durasi semua catatan',
    itemCountSuffix: 'entri',
    copyAllHistory: 'Salin Semua',
    clearAllHistory: 'Hapus Semua',
    clearAllConfirmTitle: 'Hapus Riwayat',
    clearAllConfirmMessage: 'Apakah Anda yakin ingin menghapus semua riwayat perhitungan?',
    delete: 'Hapus',
    cancel: 'Batal',
    save: 'Simpan',
    copiedHistoryToast: 'Riwayat disalin ke papan klip',
    copiedResultToast: _copiedResultId,
    copiedConversionToast: _copiedConversionId,
    settings: 'Pengaturan',
    language: 'Bahasa',
    vibration: 'Getaran Tombol',
    vibrationSubtitle: 'Bergetar lembut saat tombol ditekan',
    appearance: 'Tampilan',
    darkModeOnly: 'Mode Gelap (Tetap)',
    editLabel: 'Edit Label',
    labelHint: 'Contoh: Jam kerja / Tugas A',
    conversionsTitle: 'Konversi',
    today: 'Hari ini',
    yesterday: 'Kemarin',
    share: 'Bagikan',
    sharePrefix: '[Kalkulator Waktu]',
  );
  static String _copiedResultId(String r) => 'Disalin: $r';
  static String _copiedConversionId(String c) => 'Konversi disalin: $c';

  // 15. Tiếng Việt (ベトナム語)
  static const _vi = AppStrings(
    appTitle: 'Máy Tính Thời Gian',
    units: UnitLabels(year: 'năm', month: 'tháng', week: 'tuần', day: 'ngày', hour: 'giờ', minute: 'phút', second: 'giây'),
    history: 'Lịch sử',
    historyEmpty: 'Chưa có lịch sử',
    totalDurationHeader: 'Tổng thời lượng tất cả bản ghi',
    itemCountSuffix: 'mục',
    copyAllHistory: 'Sao chép tất cả',
    clearAllHistory: 'Xóa tất cả',
    clearAllConfirmTitle: 'Xóa lịch sử',
    clearAllConfirmMessage: 'Bạn có chắc chắn muốn xóa toàn bộ lịch sử tính toán?',
    delete: 'Xóa',
    cancel: 'Hủy',
    save: 'Lưu',
    copiedHistoryToast: 'Đã sao chép lịch sử vào bộ nhớ tạm',
    copiedResultToast: _copiedResultVi,
    copiedConversionToast: _copiedConversionVi,
    settings: 'Cài đặt',
    language: 'Ngôn ngữ',
    vibration: 'Rung bàn phím',
    vibrationSubtitle: 'Rung nhẹ khi nhấn phím',
    appearance: 'Giao diện',
    darkModeOnly: 'Chế độ tối (Cố định)',
    editLabel: 'Chỉnh sửa nhãn',
    labelHint: 'Ví dụ: Giờ làm việc / Nhiệm vụ A',
    conversionsTitle: 'Chuyển đổi',
    today: 'Hôm nay',
    yesterday: 'Hôm qua',
    share: 'Chia sẻ',
    sharePrefix: '[Máy Tính Thời Gian]',
  );
  static String _copiedResultVi(String r) => 'Đã sao chép: $r';
  static String _copiedConversionVi(String c) => 'Đã sao chép chuyển đổi: $c';

  // 16. ภาษาไทย (タイ語)
  static const _th = AppStrings(
    appTitle: 'เครื่องคำนวณเวลา',
    units: UnitLabels(year: 'ปี', month: 'เดือน', week: 'สัปดาห์', day: 'วัน', hour: 'ชม.', minute: 'นาที', second: 'วินาที'),
    history: 'ประวัติ',
    historyEmpty: 'ไม่มีประวัติ',
    totalDurationHeader: 'ระยะเวลารวมของบันทึกทั้งหมด',
    itemCountSuffix: 'รายการ',
    copyAllHistory: 'คัดลอกทั้งหมด',
    clearAllHistory: 'ล้างทั้งหมด',
    clearAllConfirmTitle: 'ล้างประวัติ',
    clearAllConfirmMessage: 'คุณแน่ใจหรือไม่ว่าต้องการลบประวัติการคำนวณทั้งหมด?',
    delete: 'ลบ',
    cancel: 'ยกเลิก',
    save: 'บันทึก',
    copiedHistoryToast: 'คัดลอกประวัติไปยังคลิปบอร์ดแล้ว',
    copiedResultToast: _copiedResultTh,
    copiedConversionToast: _copiedConversionTh,
    settings: 'การตั้งค่า',
    language: 'ภาษา',
    vibration: 'การสั่นแป้นพิมพ์',
    vibrationSubtitle: 'สั่นเบาๆ เมื่อกดปุ่ม',
    appearance: 'ลักษณะ',
    darkModeOnly: 'โหมดมืด (คงที่)',
    editLabel: 'แก้ไขป้ายกำกับ',
    labelHint: 'เช่น: เวลาทำงาน / งาน A',
    conversionsTitle: 'แปลงหน่วย',
    today: 'วันนี้',
    yesterday: 'เมื่อวาน',
    share: 'แชร์',
    sharePrefix: '[เครื่องคำนวณเวลา]',
  );
  static String _copiedResultTh(String r) => 'คัดลอกแล้ว: $r';
  static String _copiedConversionTh(String c) => 'คัดลอกการแปลงแล้ว: $c';

  // 17. Türkçe (トルコ語)
  static const _tr = AppStrings(
    appTitle: 'Zaman Hesaplayıcı',
    units: UnitLabels(year: 'yıl', month: 'ay', week: 'hf', day: 'gün', hour: 'sa', minute: 'dk', second: 'sn'),
    history: 'Geçmiş',
    historyEmpty: 'Geçmiş yok',
    totalDurationHeader: 'Tüm kayıtların toplam süresi',
    itemCountSuffix: 'öğe',
    copyAllHistory: 'Tümünü Kopyala',
    clearAllHistory: 'Tümünü Temizle',
    clearAllConfirmTitle: 'Geçmişi Temizle',
    clearAllConfirmMessage: 'Tüm hesaplama geçmişini silmek istediğinizden emin misiniz?',
    delete: 'Sil',
    cancel: 'İptal',
    save: 'Kaydet',
    copiedHistoryToast: 'Geçmiş panoya kopyalandı',
    copiedResultToast: _copiedResultTr,
    copiedConversionToast: _copiedConversionTr,
    settings: 'Ayarlar',
    language: 'Dil',
    vibration: 'Tuş Titreşimi',
    vibrationSubtitle: 'Düğmelere basıldığında hafifçe titrer',
    appearance: 'Görünüm',
    darkModeOnly: 'Karanlık Mod (Sabit)',
    editLabel: 'Etiketi Düzenle',
    labelHint: 'Örn: Çalışma saatleri / Görev A',
    conversionsTitle: 'Dönüştürmeler',
    today: 'Bugün',
    yesterday: 'Dün',
    share: 'Paylaş',
    sharePrefix: '[Zaman Hesaplayıcı]',
  );
  static String _copiedResultTr(String r) => 'Kopyalandı: $r';
  static String _copiedConversionTr(String c) => 'Dönüşüm kopyalandı: $c';

  // 18. Nederlands (オランダ語)
  static const _nl = AppStrings(
    appTitle: 'Tijd Rekenmachine',
    units: UnitLabels(year: 'jr', month: 'mnd', week: 'wk', day: 'dg', hour: 'uur', minute: 'min', second: 'sec'),
    history: 'Geschiedenis',
    historyEmpty: 'Geen geschiedenis',
    totalDurationHeader: 'Totale duur van alle records',
    itemCountSuffix: 'items',
    copyAllHistory: 'Alles kopiëren',
    clearAllHistory: 'Alles wissen',
    clearAllConfirmTitle: 'Geschiedenis wissen',
    clearAllConfirmMessage: 'Weet u zeker dat u alle berekeningsgeschiedenis wilt verwijderen?',
    delete: 'Verwijderen',
    cancel: 'Annuleren',
    save: 'Opslaan',
    copiedHistoryToast: 'Geschiedenis gekopieerd naar klembord',
    copiedResultToast: _copiedResultNl,
    copiedConversionToast: _copiedConversionNl,
    settings: 'Instellingen',
    language: 'Taal',
    vibration: 'Toetstrilling',
    vibrationSubtitle: 'Trilt lichtjes bij het indrukken van knoppen',
    appearance: 'Uiterlijk',
    darkModeOnly: 'Donkere modus (vast)',
    editLabel: 'Label bewerken',
    labelHint: 'Bijv. Werkuren / Taak A',
    conversionsTitle: 'Conversies',
    today: 'Vandaag',
    yesterday: 'Gisteren',
    share: 'Delen',
    sharePrefix: '[Tijd Rekenmachine]',
  );
  static String _copiedResultNl(String r) => 'Gekopieerd: $r';
  static String _copiedConversionNl(String c) => 'Conversie gekopieerd: $c';

  // 19. Polski (ポーランド語)
  static const _pl = AppStrings(
    appTitle: 'Kalkulator Czasu',
    units: UnitLabels(year: 'rok', month: 'mies', week: 'tydz', day: 'dni', hour: 'godz', minute: 'min', second: 'sek'),
    history: 'Historia',
    historyEmpty: 'Brak historii',
    totalDurationHeader: 'Całkowity czas wszystkich wpisów',
    itemCountSuffix: 'wpisów',
    copyAllHistory: 'Kopiuj wszystko',
    clearAllHistory: 'Wyczyść wszystko',
    clearAllConfirmTitle: 'Wyczyść historię',
    clearAllConfirmMessage: 'Czy na pewno chcesz usunąć całą historię obliczeń?',
    delete: 'Usuń',
    cancel: 'Anuluj',
    save: 'Zapisz',
    copiedHistoryToast: 'Historia skopiowana do schowka',
    copiedResultToast: _copiedResultPl,
    copiedConversionToast: _copiedConversionPl,
    settings: 'Ustawienia',
    language: 'Język',
    vibration: 'Wibracja klawiszy',
    vibrationSubtitle: 'Lekka wibracja przy dotknięciu przycisków',
    appearance: 'Wygląd',
    darkModeOnly: 'Tryb ciemny (stały)',
    editLabel: 'Edytuj etykietę',
    labelHint: 'Np. Godziny pracy / Zadanie A',
    conversionsTitle: 'Konwersje',
    today: 'Dzisiaj',
    yesterday: 'Wczoraj',
    share: 'Udostępnij',
    sharePrefix: '[Kalkulator Czasu]',
  );
  static String _copiedResultPl(String r) => 'Skopiowano: $r';
  static String _copiedConversionPl(String c) => 'Konwersja skopiowana: $c';

  // 20. বাংলা (Bengali)
  static const _bn = AppStrings(
    appTitle: 'সময় ক্যালকুলেটর',
    units: UnitLabels(year: 'বছর', month: 'মাস', week: 'সপ্তাহ', day: 'দিন', hour: 'ঘণ্টা', minute: 'মিনিট', second: 'সেকেন্ড'),
    history: 'ইতিহাস',
    historyEmpty: 'কোনো ইতিহাস নেই',
    totalDurationHeader: 'সমস্ত রেকর্ডের মোট সময়কাল',
    itemCountSuffix: 'টি',
    copyAllHistory: 'সব কপি করুন',
    clearAllHistory: 'সব মুছুন',
    clearAllConfirmTitle: 'ইতিহাস মুছুন',
    clearAllConfirmMessage: 'আপনি কি নিশ্চিত যে সমস্ত হিসাবের ইতিহাস মুছে ফেলতে চান?',
    delete: 'মুছুন',
    cancel: 'বাতিল',
    save: 'সংরক্ষণ করুন',
    copiedHistoryToast: 'সমস্ত ইতিহাস ক্লিপবোর্ডে কপি করা হয়েছে',
    copiedResultToast: _copiedResultBn,
    copiedConversionToast: _copiedConversionBn,
    settings: 'সেটিংস',
    language: 'ভাষা',
    vibration: 'কিপ্যাড কম্পন',
    vibrationSubtitle: 'বোতাম স্পর্শ করলে হালকা কম্পন',
    appearance: 'চেহারা',
    darkModeOnly: 'ডার্ক মোড (স্থায়ী)',
    editLabel: 'লেবেল সম্পাদনা',
    labelHint: 'যেমন: কাজের সময় / কাজ A',
    conversionsTitle: 'একক রূপান্তর',
    today: 'আজ',
    yesterday: 'গতকাল',
    share: 'শেয়ার করুন',
    sharePrefix: '[সময় ক্যালকুলেটর]',
  );
  static String _copiedResultBn(String r) => 'ফলাফল কপি করা হয়েছে: $r';
  static String _copiedConversionBn(String c) => 'রূপান্তর কপি করা হয়েছে: $c';

  // 21. Bahasa Melayu (Malay)
  static const _ms = AppStrings(
    appTitle: 'Kalkulator Masa',
    units: UnitLabels(year: 'thn', month: 'bln', week: 'mgg', day: 'hari', hour: 'jam', minute: 'min', second: 'dtk'),
    history: 'Sejarah',
    historyEmpty: 'Tiada sejarah',
    totalDurationHeader: 'Jumlah Tempoh Semua Rekod',
    itemCountSuffix: 'item',
    copyAllHistory: 'Salin Semua Sejarah',
    clearAllHistory: 'Kosongkan Semua Sejarah',
    clearAllConfirmTitle: 'Kosongkan Sejarah',
    clearAllConfirmMessage: 'Adakah anda pasti mahu memadam semua rekod pengiraan?',
    delete: 'Padam',
    cancel: 'Batal',
    save: 'Simpan',
    copiedHistoryToast: 'Semua sejarah disalin ke papan keratan',
    copiedResultToast: _copiedResultMs,
    copiedConversionToast: _copiedConversionMs,
    settings: 'Tetapan',
    language: 'Bahasa',
    vibration: 'Getaran Papan Kekunci',
    vibrationSubtitle: 'Bergetar sedikit apabila butang ditekan',
    appearance: 'Rupa',
    darkModeOnly: 'Mod Gelap (Kekal)',
    editLabel: 'Edit Label',
    labelHint: 'Cth: Jam kerja / Tugas A',
    conversionsTitle: 'Penukaran',
    today: 'Hari ini',
    yesterday: 'Semalam',
    share: 'Kongsi',
    sharePrefix: '[Kalkulator Masa]',
  );
  static String _copiedResultMs(String r) => 'Hasil disalin: $r';
  static String _copiedConversionMs(String c) => 'Penukaran disalin: $c';

  // 22. Filipino (Filipino / Tagalog)
  static const _fil = AppStrings(
    appTitle: 'Kalkulator ng Oras',
    units: UnitLabels(year: 'taon', month: 'buwan', week: 'linggo', day: 'araw', hour: 'oras', minute: 'min', second: 'seg'),
    history: 'Kasaysayan',
    historyEmpty: 'Walang kasaysayan',
    totalDurationHeader: 'Kabuuang Tagal ng Lahat ng Rekord',
    itemCountSuffix: 'aytem',
    copyAllHistory: 'Kopyahin Lahat',
    clearAllHistory: 'I-clear Lahat',
    clearAllConfirmTitle: 'I-clear ang Kasaysayan',
    clearAllConfirmMessage: 'Sigurado ka bang gusto mong tanggalin ang lahat ng tala ng kalkulasyon?',
    delete: 'Tanggalin',
    cancel: 'Kanselahin',
    save: 'I-save',
    copiedHistoryToast: 'Nakopya ang lahat ng kasaysayan sa clipboard',
    copiedResultToast: _copiedResultFil,
    copiedConversionToast: _copiedConversionFil,
    settings: 'Mga Setting',
    language: 'Wika',
    vibration: 'Panginginig ng Keypad',
    vibrationSubtitle: 'Bahagyang manginig kapag pinindot ang mga button',
    appearance: 'Hitsura',
    darkModeOnly: 'Dark Mode (Palagi)',
    editLabel: 'I-edit ang Label',
    labelHint: 'Hal: Oras ng trabaho / Gawain A',
    conversionsTitle: 'Mga Pagpapalit',
    today: 'Ngayon',
    yesterday: 'Kahapon',
    share: 'Ibahagi',
    sharePrefix: '[Kalkulator ng Oras]',
  );
  static String _copiedResultFil(String r) => 'Nakopya ang resulta: $r';
  static String _copiedConversionFil(String c) => 'Nakopya ang konbersyon: $c';

  // 23. Svenska (Swedish)
  static const _sv = AppStrings(
    appTitle: 'Tidskalkylator',
    units: UnitLabels(year: 'år', month: 'mån', week: 'v', day: 'd', hour: 'tim', minute: 'min', second: 'sek'),
    history: 'Historik',
    historyEmpty: 'Ingen historik än',
    totalDurationHeader: 'Total varaktighet för alla poster',
    itemCountSuffix: 'poster',
    copyAllHistory: 'Kopiera all historik',
    clearAllHistory: 'Rensa all historik',
    clearAllConfirmTitle: 'Rensa historik',
    clearAllConfirmMessage: 'Är du säker på att du vill ta bort alla beräkningsposter?',
    delete: 'Radera',
    cancel: 'Avbryt',
    save: 'Spara',
    copiedHistoryToast: 'All historik kopierad till urklipp',
    copiedResultToast: _copiedResultSv,
    copiedConversionToast: _copiedConversionSv,
    settings: 'Inställningar',
    language: 'Språk',
    vibration: 'Knappvibration',
    vibrationSubtitle: 'Vibrera lätt när knappar trycks ned',
    appearance: 'Utseende',
    darkModeOnly: 'Mörkt läge (alltid)',
    editLabel: 'Redigera etikett',
    labelHint: 't.ex. Arbetstid / Uppgift A',
    conversionsTitle: 'Omvandlingar',
    today: 'Idag',
    yesterday: 'Igår',
    share: 'Dela',
    sharePrefix: '[Tidskalkylator]',
  );
  static String _copiedResultSv(String r) => 'Kopierat resultat: $r';
  static String _copiedConversionSv(String c) => 'Kopierad omvandling: $c';

  // 24. Norsk (Norwegian)
  static const _no = AppStrings(
    appTitle: 'Tidskalkulator',
    units: UnitLabels(year: 'år', month: 'mnd', week: 'uke', day: 'dag', hour: 't', minute: 'min', second: 'sek'),
    history: 'Historikk',
    historyEmpty: 'Ingen historikk ennå',
    totalDurationHeader: 'Total varighet for alle oppføringer',
    itemCountSuffix: 'elementer',
    copyAllHistory: 'Kopier all historikk',
    clearAllHistory: 'Tøm all historikk',
    clearAllConfirmTitle: 'Tøm historikk',
    clearAllConfirmMessage: 'Er du sikker på at du vil slette all beregningshistorikk?',
    delete: 'Slett',
    cancel: 'Avbryt',
    save: 'Lagre',
    copiedHistoryToast: 'All historikk kopiert til utklippstavlen',
    copiedResultToast: _copiedResultNo,
    copiedConversionToast: _copiedConversionNo,
    settings: 'Innstillinger',
    language: 'Språk',
    vibration: 'Tastaturvibrasjon',
    vibrationSubtitle: 'Vibrer lett når du trykker på knapper',
    appearance: 'Utseende',
    darkModeOnly: 'Mørk modus (alltid)',
    editLabel: 'Rediger etikett',
    labelHint: 'f.eks. Arbeidstid / Oppgave A',
    conversionsTitle: 'Konverteringer',
    today: 'I dag',
    yesterday: 'I går',
    share: 'Del',
    sharePrefix: '[Tidskalkulator]',
  );
  static String _copiedResultNo(String r) => 'Kopiert resultat: $r';
  static String _copiedConversionNo(String c) => 'Kopiert konvertering: $c';

  // 25. Українська (Ukrainian)
  static const _uk = AppStrings(
    appTitle: 'Калькулятор Часу',
    units: UnitLabels(year: 'р', month: 'міс', week: 'тиж', day: 'д', hour: 'год', minute: 'хв', second: 'сек'),
    history: 'Історія',
    historyEmpty: 'Історія порожня',
    totalDurationHeader: 'Загальна тривалість усіх записів',
    itemCountSuffix: 'записів',
    copyAllHistory: 'Копіювати всю історію',
    clearAllHistory: 'Очистити всю історію',
    clearAllConfirmTitle: 'Очистити історію',
    clearAllConfirmMessage: 'Ви впевнені, що хочете видалити всю історію обчислень?',
    delete: 'Видалити',
    cancel: 'Скасувати',
    save: 'Зберегти',
    copiedHistoryToast: 'Вся історія скопійована в буфер обміну',
    copiedResultToast: _copiedResultUk,
    copiedConversionToast: _copiedConversionUk,
    settings: 'Налаштування',
    language: 'Мова',
    vibration: 'Вібрація клавіш',
    vibrationSubtitle: 'Легка вібрація при натисканні кнопок',
    appearance: 'Вигляд',
    darkModeOnly: 'Темний режим (завжди)',
    editLabel: 'Редагувати мітку',
    labelHint: 'наприклад: Робочі години / Завдання А',
    conversionsTitle: 'Конвертація',
    today: 'Сьогодні',
    yesterday: 'Вчора',
    share: 'Поділитися',
    sharePrefix: '[Калькулятор Часу]',
  );
  static String _copiedResultUk(String r) => 'Скопійовано: $r';
  static String _copiedConversionUk(String c) => 'Перетворення скопійовано: $c';

  // 26. Dansk (Danish)
  static const _da = AppStrings(
    appTitle: 'Tidsregner',
    units: UnitLabels(year: 'år', month: 'md', week: 'uge', day: 'dag', hour: 't', minute: 'min', second: 'sek'),
    history: 'Historik',
    historyEmpty: 'Ingen historik endnu',
    totalDurationHeader: 'Samlet varighed for alle poster',
    itemCountSuffix: 'elementer',
    copyAllHistory: 'Kopier al historik',
    clearAllHistory: 'Ryd al historik',
    clearAllConfirmTitle: 'Ryd historik',
    clearAllConfirmMessage: 'Er du sikker på, at du vil slette al beregningshistorik?',
    delete: 'Slet',
    cancel: 'Annuller',
    save: 'Gem',
    copiedHistoryToast: 'Al historik kopieret til udklipsholderen',
    copiedResultToast: _copiedResultDa,
    copiedConversionToast: _copiedConversionDa,
    settings: 'Indstillinger',
    language: 'Sprog',
    vibration: 'Tastaturvibration',
    vibrationSubtitle: 'Vibrer let ved tastetryk',
    appearance: 'Udseende',
    darkModeOnly: 'Mørk tilstand (fast)',
    editLabel: 'Rediger etiket',
    labelHint: 'f.eks. Arbejdstid / Opgave A',
    conversionsTitle: 'Konverteringer',
    today: 'I dag',
    yesterday: 'I går',
    share: 'Del',
    sharePrefix: '[Tidsregner]',
  );
  static String _copiedResultDa(String r) => 'Kopieret resultat: $r';
  static String _copiedConversionDa(String c) => 'Kopieret konvertering: $c';

  // 27. Suomi (Finnish)
  static const _fi = AppStrings(
    appTitle: 'Aikalaskin',
    units: UnitLabels(year: 'vuosi', month: 'kk', week: 'vko', day: 'pv', hour: 't', minute: 'min', second: 's'),
    history: 'Historia',
    historyEmpty: 'Ei vielä historiaa',
    totalDurationHeader: 'Kaikkien tietueiden kokonaiskesto',
    itemCountSuffix: 'kpl',
    copyAllHistory: 'Kopioi koko historia',
    clearAllHistory: 'Tyhjennä koko historia',
    clearAllConfirmTitle: 'Tyhjennä historia',
    clearAllConfirmMessage: 'Haluatko varmasti poistaa koko laskentahistorian?',
    delete: 'Poista',
    cancel: 'Peruuta',
    save: 'Tallenna',
    copiedHistoryToast: 'Koko historia kopioitu leikepöydälle',
    copiedResultToast: _copiedResultFi,
    copiedConversionToast: _copiedConversionFi,
    settings: 'Asetukset',
    language: 'Kieli',
    vibration: 'Näppäimistön värinä',
    vibrationSubtitle: 'Värise kevyesti painettaessa painikkeita',
    appearance: 'Ulkoasu',
    darkModeOnly: 'Tumma tila (kiinteä)',
    editLabel: 'Muokkaa tunnistetta',
    labelHint: 'esim. Työtunnit / Tehtävä A',
    conversionsTitle: 'Muunnokset',
    today: 'Tänään',
    yesterday: 'Eilen',
    share: 'Jaa',
    sharePrefix: '[Aikalaskin]',
  );
  static String _copiedResultFi(String r) => 'Kopioitu tulos: $r';
  static String _copiedConversionFi(String c) => 'Kopioitu muunnos: $c';

  // 28. Čeština (Czech)
  static const _cs = AppStrings(
    appTitle: 'Kalkulačka Času',
    units: UnitLabels(year: 'rok', month: 'měs', week: 'týd', day: 'den', hour: 'hod', minute: 'min', second: 'sek'),
    history: 'Historie',
    historyEmpty: 'Zatím žádná historie',
    totalDurationHeader: 'Celková doba trvání všech záznamů',
    itemCountSuffix: 'položek',
    copyAllHistory: 'Kopírovat celou historii',
    clearAllHistory: 'Vymazat celou historii',
    clearAllConfirmTitle: 'Vymazat historii',
    clearAllConfirmMessage: 'Opravdu chcete smazat celou historii výpočtů?',
    delete: 'Smazat',
    cancel: 'Zrušit',
    save: 'Uložit',
    copiedHistoryToast: 'Celá historie zkopírována do schránky',
    copiedResultToast: _copiedResultCs,
    copiedConversionToast: _copiedConversionCs,
    settings: 'Nastavení',
    language: 'Jazyk',
    vibration: 'Vibrace klávesnice',
    vibrationSubtitle: 'Při stisknutí tlačítek lehce zavibrovat',
    appearance: 'Vzhled',
    darkModeOnly: 'Tmavý režim (trvale)',
    editLabel: 'Upravit štítek',
    labelHint: 'např. Pracovní doba / Úkol A',
    conversionsTitle: 'Převody',
    today: 'Dnes',
    yesterday: 'Včera',
    share: 'Sdílet',
    sharePrefix: '[Kalkulačka Času]',
  );
  static String _copiedResultCs(String r) => 'Zkopírovaný výsledek: $r';
  static String _copiedConversionCs(String c) => 'Zkopírovaný převod: $c';

  // 29. Ελληνικά (Greek)
  static const _el = AppStrings(
    appTitle: 'Αριθμομηχανή Χρόνου',
    units: UnitLabels(year: 'έτος', month: 'μήνας', week: 'εβδ', day: 'ημέρα', hour: 'ώρα', minute: 'λεπτό', second: 'δευτ'),
    history: 'Ιστορικό',
    historyEmpty: 'Δεν υπάρχει ιστορικό ακόμα',
    totalDurationHeader: 'Συνολική διάρκεια όλων των εγγραφών',
    itemCountSuffix: 'στοιχεία',
    copyAllHistory: 'Αντιγραφή όλου του ιστορικού',
    clearAllHistory: 'Εκκαθάριση όλου του ιστορικού',
    clearAllConfirmTitle: 'Εκκαθάριση ιστορικού',
    clearAllConfirmMessage: 'Είστε βέβαιοι ότι θέλετε να διαγράψετε όλο το ιστορικό υπολογισμών;',
    delete: 'Διαγραφή',
    cancel: 'Ακύρωση',
    save: 'Αποθήκευση',
    copiedHistoryToast: 'Όλο το ιστορικό αντιγράφηκε στο πρόχειρο',
    copiedResultToast: _copiedResultEl,
    copiedConversionToast: _copiedConversionEl,
    settings: 'Ρυθμίσεις',
    language: 'Γλώσσα',
    vibration: 'Δόνηση πληκτρολογίου',
    vibrationSubtitle: 'Ελαφριά δόνηση κατά το πάτημα των πλήκτρων',
    appearance: 'Εμφάνιση',
    darkModeOnly: 'Σκοτεινή λειτουργία (σταθερή)',
    editLabel: 'Επεξεργασία ετικέτας',
    labelHint: 'π.χ. Ώρες εργασίας / Εργασία Α',
    conversionsTitle: 'Μετατροπές',
    today: 'Σήμερα',
    yesterday: 'Χθες',
    share: 'Κοινοποίηση',
    sharePrefix: '[Αριθμομηχανή Χρόνου]',
  );
  static String _copiedResultEl(String r) => 'Αντιγράφηκε: $r';
  static String _copiedConversionEl(String c) => 'Αντιγράφηκε μετατροπή: $c';

  // 30. Română (Romanian)
  static const _ro = AppStrings(
    appTitle: 'Calculator de Timp',
    units: UnitLabels(year: 'an', month: 'lună', week: 'săpt', day: 'zi', hour: 'oră', minute: 'min', second: 'sec'),
    history: 'Istoric',
    historyEmpty: 'Niciun istoric încă',
    totalDurationHeader: 'Durata totală a tuturor înregistrărilor',
    itemCountSuffix: 'elemente',
    copyAllHistory: 'Copiază tot istoricul',
    clearAllHistory: 'Șterge tot istoricul',
    clearAllConfirmTitle: 'Șterge istoricul',
    clearAllConfirmMessage: 'Sigur doriți să ștergeți tot istoricul calculelor?',
    delete: 'Șterge',
    cancel: 'Anulează',
    save: 'Salvează',
    copiedHistoryToast: 'Tot istoricul a fost copiat în clipboard',
    copiedResultToast: _copiedResultRo,
    copiedConversionToast: _copiedConversionRo,
    settings: 'Setări',
    language: 'Limbă',
    vibration: 'Vibrație tastatură',
    vibrationSubtitle: 'Vibrează ușor la apăsarea tastelor',
    appearance: 'Aspect',
    darkModeOnly: 'Mod întunecat (permanent)',
    editLabel: 'Editează eticheta',
    labelHint: 'ex. Ore de lucru / Sarcina A',
    conversionsTitle: 'Conversii',
    today: 'Azi',
    yesterday: 'Ieri',
    share: 'Distribuie',
    sharePrefix: '[Calculator de Timp]',
  );
  static String _copiedResultRo(String r) => 'Rezultat copiat: $r';
  static String _copiedConversionRo(String c) => 'Conversie copiată: $c';

  // 31. Magyar (Hungarian)
  static const _hu = AppStrings(
    appTitle: 'Időszámológép',
    units: UnitLabels(year: 'év', month: 'hó', week: 'hét', day: 'nap', hour: 'óra', minute: 'perc', second: 'mp'),
    history: 'Előzmények',
    historyEmpty: 'Még nincsenek előzmények',
    totalDurationHeader: 'Minden rekord összidőtartama',
    itemCountSuffix: 'tétel',
    copyAllHistory: 'Összes előzmény másolása',
    clearAllHistory: 'Összes előzmény törlése',
    clearAllConfirmTitle: 'Előzmények törlése',
    clearAllConfirmMessage: 'Biztosan törölni szeretné a teljes számítási előzményt?',
    delete: 'Törlés',
    cancel: 'Mégse',
    save: 'Mentés',
    copiedHistoryToast: 'Összes előzmény a vágólapra másolva',
    copiedResultToast: _copiedResultHu,
    copiedConversionToast: _copiedConversionHu,
    settings: 'Beállítások',
    language: 'Nyelv',
    vibration: 'Billentyűzet rezgés',
    vibrationSubtitle: 'Enyhe rezgés a gombok megnyomásakor',
    appearance: 'Megjelenés',
    darkModeOnly: 'Sötét mód (állandó)',
    editLabel: 'Címke szerkesztése',
    labelHint: 'pl. Munkaórák / A feladat',
    conversionsTitle: 'Átváltások',
    today: 'Ma',
    yesterday: 'Tegnap',
    share: 'Megosztás',
    sharePrefix: '[Időszámológép]',
  );
  static String _copiedResultHu(String r) => 'Másolt eredmény: $r';
  static String _copiedConversionHu(String c) => 'Másolt átváltás: $c';
}
