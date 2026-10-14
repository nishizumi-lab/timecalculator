enum DurationUnit {
  year('年', 31557600),
  month('ヶ月', 2629800),
  week('週間', 604800),
  day('日', 86400),
  hour('時間', 3600),
  minute('分', 60),
  second('秒', 1);

  const DurationUnit(this.label, this.seconds);

  final String label;
  final double seconds;
}
