const _months = [
  'января',
  'февраля',
  'марта',
  'апреля',
  'мая',
  'июня',
  'июля',
  'августа',
  'сентября',
  'октября',
  'ноября',
  'декабря',
];

String twoDigits(int value) => value.toString().padLeft(2, '0');

String formatClock(DateTime time) {
  final local = time.toLocal();
  return '${twoDigits(local.hour)}:${twoDigits(local.minute)}';
}

String formatReadingWhen(DateTime time, DateTime now) {
  final local = time.toLocal();
  final current = now.toLocal();
  final clock = formatClock(local);
  final day = DateTime(local.year, local.month, local.day);
  final today = DateTime(current.year, current.month, current.day);
  if (day == today) return 'Сегодня, $clock';
  final yesterday = today.subtract(const Duration(days: 1));
  if (day == yesterday) return 'Вчера, $clock';
  return '${local.day} ${_months[local.month - 1]}, $clock';
}

String formatFullWhen(DateTime time) {
  final local = time.toLocal();
  return '${local.day} ${_months[local.month - 1]}, ${formatClock(local)}';
}

String formatPressure(int systolic, int diastolic) => '$systolic / $diastolic';
