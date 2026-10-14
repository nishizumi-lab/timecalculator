import '../models/duration_unit.dart';
import '../models/expression_value.dart';
import 'parser.dart';
import 'parser_error.dart';
import 'tokenizer.dart';

class TimeExpressionParser {
  static const Map<String, DurationUnit> _units = {
    // 日本語 (Japanese)
    '年': DurationUnit.year,
    'ヶ月': DurationUnit.month,
    '月': DurationUnit.month,
    '週間': DurationUnit.week,
    '週': DurationUnit.week,
    '日': DurationUnit.day,
    '時間': DurationUnit.hour,
    '時': DurationUnit.hour,
    '分': DurationUnit.minute,
    '秒': DurationUnit.second,
    // 英語 (English)
    'year': DurationUnit.year,
    'years': DurationUnit.year,
    'yr': DurationUnit.year,
    'y': DurationUnit.year,
    'month': DurationUnit.month,
    'months': DurationUnit.month,
    'mo': DurationUnit.month,
    'week': DurationUnit.week,
    'weeks': DurationUnit.week,
    'wk': DurationUnit.week,
    'w': DurationUnit.week,
    'day': DurationUnit.day,
    'days': DurationUnit.day,
    'd': DurationUnit.day,
    'hour': DurationUnit.hour,
    'hours': DurationUnit.hour,
    'hr': DurationUnit.hour,
    'hrs': DurationUnit.hour,
    'h': DurationUnit.hour,
    'minute': DurationUnit.minute,
    'minutes': DurationUnit.minute,
    'min': DurationUnit.minute,
    'mins': DurationUnit.minute,
    'm': DurationUnit.minute,
    'second': DurationUnit.second,
    'seconds': DurationUnit.second,
    'sec': DurationUnit.second,
    'secs': DurationUnit.second,
    's': DurationUnit.second,
    // 中国語 簡体字・繁体字 (Chinese)
    '小时': DurationUnit.hour,
    '小時': DurationUnit.hour,
    '时': DurationUnit.hour,
    '周': DurationUnit.week,
    '天': DurationUnit.day,
    // 韓国語 (Korean)
    '년': DurationUnit.year,
    '월': DurationUnit.month,
    '주': DurationUnit.week,
    '일': DurationUnit.day,
    '시간': DurationUnit.hour,
    '분': DurationUnit.minute,
    '초': DurationUnit.second,
    // スペイン語 / フランス語 (Spanish / French)
    'año': DurationUnit.year,
    'an': DurationUnit.year,
    'mes': DurationUnit.month,
    'mois': DurationUnit.month,
    'sem': DurationUnit.week,
    'j': DurationUnit.day,
    // ドイツ語 (German)
    'Jahr': DurationUnit.year,
    'Jahre': DurationUnit.year,
    'J': DurationUnit.year,
    'Monat': DurationUnit.month,
    'Monate': DurationUnit.month,
    'M': DurationUnit.month,
    'Woche': DurationUnit.week,
    'Wochen': DurationUnit.week,
    'W': DurationUnit.week,
    'Tag': DurationUnit.day,
    'Tage': DurationUnit.day,
    'T': DurationUnit.day,
    'Std': DurationUnit.hour,
    'Stunde': DurationUnit.hour,
    'Stunden': DurationUnit.hour,
    'Min': DurationUnit.minute,
    'Minute': DurationUnit.minute,
    'Minuten': DurationUnit.minute,
    'Sek': DurationUnit.second,
    'Sekunde': DurationUnit.second,
    'Sekunden': DurationUnit.second,
    // イタリア語 (Italian)
    'anno': DurationUnit.year,
    'mese': DurationUnit.month,
    'sett': DurationUnit.week,
    'giorno': DurationUnit.day,
    'g': DurationUnit.day,
    'ora': DurationUnit.hour,
    'ore': DurationUnit.hour,
    // ポルトガル語 (Portuguese)
    'ano': DurationUnit.year,
    'mês': DurationUnit.month,
    'dia': DurationUnit.day,
    'hora': DurationUnit.hour,
    'horas': DurationUnit.hour,
    'seg': DurationUnit.second,
    // ロシア語 (Russian)
    'года': DurationUnit.year,
    'лет': DurationUnit.year,
    'г': DurationUnit.year,
    'месяц': DurationUnit.month,
    'месяца': DurationUnit.month,
    'месяцев': DurationUnit.month,
    'мес': DurationUnit.month,
    'неделя': DurationUnit.week,
    'недели': DurationUnit.week,
    'недель': DurationUnit.week,
    'нед': DurationUnit.week,
    'день': DurationUnit.day,
    'дня': DurationUnit.day,
    'дней': DurationUnit.day,
    'д': DurationUnit.day,
    'час': DurationUnit.hour,
    'часа': DurationUnit.hour,
    'часов': DurationUnit.hour,
    'ч': DurationUnit.hour,
    'минута': DurationUnit.minute,
    'минуты': DurationUnit.minute,
    'минут': DurationUnit.minute,
    'мин': DurationUnit.minute,
    'секунда': DurationUnit.second,
    'секунды': DurationUnit.second,
    'секунд': DurationUnit.second,
    'сек': DurationUnit.second,
    'с': DurationUnit.second,
    // ヒンディー語 (Hindi)
    'वर्ष': DurationUnit.year,
    'माह': DurationUnit.month,
    'महीने': DurationUnit.month,
    'सप्ताह': DurationUnit.week,
    'दिन': DurationUnit.day,
    'घंटे': DurationUnit.hour,
    'घंटा': DurationUnit.hour,
    'मिनट': DurationUnit.minute,
    'सेकंड': DurationUnit.second,
    // アラビア語 (Arabic)
    'سنة': DurationUnit.year,
    'سنوات': DurationUnit.year,
    'شهر': DurationUnit.month,
    'أشهر': DurationUnit.month,
    'أسبوع': DurationUnit.week,
    'أسابيع': DurationUnit.week,
    'يوم': DurationUnit.day,
    'أيام': DurationUnit.day,
    'ساعة': DurationUnit.hour,
    'ساعات': DurationUnit.hour,
    'دقيقة': DurationUnit.minute,
    'دقائق': DurationUnit.minute,
    'ثانية': DurationUnit.second,
    'ثواني': DurationUnit.second,
    // インドネシア語 (Indonesian)
    'tahun': DurationUnit.year,
    'thn': DurationUnit.year,
    'bulan': DurationUnit.month,
    'bln': DurationUnit.month,
    'minggu': DurationUnit.week,
    'mgg': DurationUnit.week,
    'hari': DurationUnit.day,
    'jam': DurationUnit.hour,
    'menit': DurationUnit.minute,
    'mnt': DurationUnit.minute,
    'detik': DurationUnit.second,
    'dtk': DurationUnit.second,
    // ベトナム語 (Vietnamese)
    'năm': DurationUnit.year,
    'tháng': DurationUnit.month,
    'tuần': DurationUnit.week,
    'ngày': DurationUnit.day,
    'giờ': DurationUnit.hour,
    'phút': DurationUnit.minute,
    'giây': DurationUnit.second,
    // タイ語 (Thai)
    'ปี': DurationUnit.year,
    'เดือน': DurationUnit.month,
    'สัปดาห์': DurationUnit.week,
    'วัน': DurationUnit.day,
    'ชม.': DurationUnit.hour,
    'ชั่วโมง': DurationUnit.hour,
    'นาที': DurationUnit.minute,
    'วินาที': DurationUnit.second,
    // トルコ語 (Turkish)
    'yıl': DurationUnit.year,
    'ay': DurationUnit.month,
    'hafta': DurationUnit.week,
    'hf': DurationUnit.week,
    'gün': DurationUnit.day,
    'saat': DurationUnit.hour,
    'sa': DurationUnit.hour,
    'dakika': DurationUnit.minute,
    'dk': DurationUnit.minute,
    'saniye': DurationUnit.second,
    'sn': DurationUnit.second,
    // オランダ語 (Dutch)
    'jaar': DurationUnit.year,
    'jr': DurationUnit.year,
    'maand': DurationUnit.month,
    'mnd': DurationUnit.month,
    'dag': DurationUnit.day,
    'dg': DurationUnit.day,
    'uur': DurationUnit.hour,
    // ポーランド語 (Polish)
    'rok': DurationUnit.year,
    'lata': DurationUnit.year,
    'lat': DurationUnit.year,
    'miesiąc': DurationUnit.month,
    'miesiące': DurationUnit.month,
    'miesięcy': DurationUnit.month,
    'mies': DurationUnit.month,
    'tydzień': DurationUnit.week,
    'tygodnie': DurationUnit.week,
    'tygodni': DurationUnit.week,
    'tydz': DurationUnit.week,
    'dzień': DurationUnit.day,
    'dni': DurationUnit.day,
    'godzina': DurationUnit.hour,
    'godziny': DurationUnit.hour,
    'godzin': DurationUnit.hour,
    'godz': DurationUnit.hour,
    'minuta': DurationUnit.minute,
    'minuty': DurationUnit.minute,
    'sekunda': DurationUnit.second,
    'sekundy': DurationUnit.second,
    // ベンガル語 (Bengali)
    'বছর': DurationUnit.year,
    'মাস': DurationUnit.month,
    'সপ্তাহ': DurationUnit.week,
    'দিন': DurationUnit.day,
    'ঘণ্টা': DurationUnit.hour,
    'ঘন্টা': DurationUnit.hour,
    'মিনিট': DurationUnit.minute,
    'সেকেন্ড': DurationUnit.second,
    // マレー語 (Malay)
    'minit': DurationUnit.minute,
    // フィリピン語 (Filipino)
    'taon': DurationUnit.year,
    'buwan': DurationUnit.month,
    'linggo': DurationUnit.week,
    'araw': DurationUnit.day,
    'oras': DurationUnit.hour,
    'segundo': DurationUnit.second,
    // スウェーデン語 (Swedish)
    'år': DurationUnit.year,
    'månad': DurationUnit.month,
    'månader': DurationUnit.month,
    'mån': DurationUnit.month,
    'vecka': DurationUnit.week,
    'veckor': DurationUnit.week,
    'v': DurationUnit.week,
    'dagar': DurationUnit.day,
    'timme': DurationUnit.hour,
    'timmar': DurationUnit.hour,
    'tim': DurationUnit.hour,
    'minut': DurationUnit.minute,
    'minuter': DurationUnit.minute,
    'sekund': DurationUnit.second,
    'sekunder': DurationUnit.second,
    // ノルウェー語 (Norwegian)
    'måned': DurationUnit.month,
    'måneder': DurationUnit.month,
    'uke': DurationUnit.week,
    'uker': DurationUnit.week,
    'timer': DurationUnit.hour,
    'time': DurationUnit.hour,
    't': DurationUnit.hour,
    'minutt': DurationUnit.minute,
    'minutter': DurationUnit.minute,
    // ウクライナ語 (Ukrainian)
    'рік': DurationUnit.year,
    'роки': DurationUnit.year,
    'років': DurationUnit.year,
    'р': DurationUnit.year,
    'місяці': DurationUnit.month,
    'місяців': DurationUnit.month,
    'міс': DurationUnit.month,
    'тиждень': DurationUnit.week,
    'тижні': DurationUnit.week,
    'тижнів': DurationUnit.week,
    'тиж': DurationUnit.week,
    'днів': DurationUnit.day,
    'дні': DurationUnit.day,
    'година': DurationUnit.hour,
    'години': DurationUnit.hour,
    'годин': DurationUnit.hour,
    'год': DurationUnit.hour,
    'хвилина': DurationUnit.minute,
    'хвилини': DurationUnit.minute,
    'хвилин': DurationUnit.minute,
    'хв': DurationUnit.minute,
    // デンマーク語 (Danish)
    'md': DurationUnit.month,
    'uger': DurationUnit.week,
    'uge': DurationUnit.week,
    'dage': DurationUnit.day,
    'sek': DurationUnit.second,
    // フィンランド語 (Finnish)
    'vuosi': DurationUnit.year,
    'vuotta': DurationUnit.year,
    'kuukausi': DurationUnit.month,
    'kuukautta': DurationUnit.month,
    'kk': DurationUnit.month,
    'viikko': DurationUnit.week,
    'viikkoa': DurationUnit.week,
    'vko': DurationUnit.week,
    'päivä': DurationUnit.day,
    'päivää': DurationUnit.day,
    'pv': DurationUnit.day,
    'tunti': DurationUnit.hour,
    'tuntia': DurationUnit.hour,
    'minuutti': DurationUnit.minute,
    'minuuttia': DurationUnit.minute,
    'sekunti': DurationUnit.second,
    'sekuntia': DurationUnit.second,
    // チェコ語 (Czech)
    'roky': DurationUnit.year,
    'měsíce': DurationUnit.month,
    'měsíců': DurationUnit.month,
    'měsíc': DurationUnit.month,
    'měs': DurationUnit.month,
    'týden': DurationUnit.week,
    'týdny': DurationUnit.week,
    'týdnů': DurationUnit.week,
    'týd': DurationUnit.week,
    'dny': DurationUnit.day,
    'den': DurationUnit.day,
    'hodina': DurationUnit.hour,
    'hodiny': DurationUnit.hour,
    'hodin': DurationUnit.hour,
    'hod': DurationUnit.hour,
    // ギリシャ語 (Greek)
    'έτος': DurationUnit.year,
    'έτη': DurationUnit.year,
    'μήνας': DurationUnit.month,
    'μήνες': DurationUnit.month,
    'μηνών': DurationUnit.month,
    'εβδομάδα': DurationUnit.week,
    'εβδομάδες': DurationUnit.week,
    'εβδ': DurationUnit.week,
    'ημέρα': DurationUnit.day,
    'ημέρες': DurationUnit.day,
    'μέρα': DurationUnit.day,
    'μέρες': DurationUnit.day,
    'ώρα': DurationUnit.hour,
    'ώρες': DurationUnit.hour,
    'ωρών': DurationUnit.hour,
    'λεπτό': DurationUnit.minute,
    'λεπτά': DurationUnit.minute,
    'λεπτών': DurationUnit.minute,
    'δευτερόλεπτο': DurationUnit.second,
    'δευτερόλεπτα': DurationUnit.second,
    'δευτ': DurationUnit.second,
    // ルーマニア語 (Romanian)
    'ani': DurationUnit.year,
    'lună': DurationUnit.month,
    'luni': DurationUnit.month,
    'săptămână': DurationUnit.week,
    'săptămâni': DurationUnit.week,
    'săpt': DurationUnit.week,
    'zi': DurationUnit.day,
    'zile': DurationUnit.day,
    'oră': DurationUnit.hour,
    'secundă': DurationUnit.second,
    'secunde': DurationUnit.second,
    // ハンガリー語 (Hungarian)
    'év': DurationUnit.year,
    'hónap': DurationUnit.month,
    'hó': DurationUnit.month,
    'hetek': DurationUnit.week,
    'hét': DurationUnit.week,
    'napok': DurationUnit.day,
    'nap': DurationUnit.day,
    'órák': DurationUnit.hour,
    'óra': DurationUnit.hour,
    'percek': DurationUnit.minute,
    'perc': DurationUnit.minute,
    'másodperc': DurationUnit.second,
    'mp': DurationUnit.second,
  };

  static Map<String, DurationUnit> get units => _units;

  static DurationUnit? getUnit(String lexeme) => _units[lexeme];

  /// 長さ降順でソートされた単位候補のリスト（最長一致用）
  static final List<String> unitCandidates = () {
    final list = _units.keys.toList();
    list.sort((a, b) {
      final lenComp = b.length.compareTo(a.length);
      return lenComp != 0 ? lenComp : a.compareTo(b);
    });
    return List<String>.unmodifiable(list);
  }();

  static final _whitespaceRegex = RegExp(r'[\s\u3000]+');
  static final _trailingOperatorsRegex = RegExp(r'[+\-−×÷*/]+$');

  EvaluationState evaluate(String source) {
    try {
      final normalized = source
          .replaceAll(_whitespaceRegex, '')
          .replaceFirst(_trailingOperatorsRegex, '');
      if (normalized.isEmpty) {
        return const EvaluationState(isValid: false);
      }
      final tokens = Tokenizer(normalized).tokenize();
      final parser = Parser(tokens);
      final value = parser.parseExpression();
      if (!parser.isAtEnd) {
        throw const ParserException(ParserErrorCode.unexpectedEnd);
      }
      final isFinite = switch (value.kind) {
        ValueKind.duration => value.durationSeconds?.isFinite ?? false,
        ValueKind.scalar => value.scalar?.isFinite ?? false,
      };
      if (!isFinite) {
        throw const ParserException(ParserErrorCode.generalError);
      }
      if (value.kind == ValueKind.duration &&
          (value.durationSeconds?.abs() ?? 0) >= 1e18) {
        throw const ParserException(ParserErrorCode.generalError);
      }
      return EvaluationState(isValid: true, value: value);
    } on ParserException catch (error) {
      return EvaluationState(
        isValid: false,
        errorCode: error.code,
        errorDetails: error.details,
        error: _defaultErrorMessage(error.code, error.details),
      );
    } on FormatException catch (error) {
      return EvaluationState(
        isValid: false,
        errorCode: ParserErrorCode.generalError,
        error: error.message,
      );
    } catch (_) {
      return const EvaluationState(
        isValid: false,
        errorCode: ParserErrorCode.generalError,
        error: '式を計算できません',
      );
    }
  }

  static String _defaultErrorMessage(ParserErrorCode code, [String? details]) {
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
        return details != null ? '未対応の文字です: $details' : '未対応の文字です';
      case ParserErrorCode.generalError:
        return '式を計算できません';
    }
  }
}
