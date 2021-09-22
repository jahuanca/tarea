import 'package:intl/intl.dart';

String formatoFechaExploreType(DateTime date, int type, int value) {
  if (date == null) return '';
  DateTime currentDate;
  switch (type) {
    case 0:
      return DateFormat('dd').format(date.subtract(Duration(days: value))) +
          " de " +
          DateFormat('MMMM', 'es')
              .format(date.subtract(Duration(days: value))) +
          " del " +
          DateFormat('yyyy').format(date.subtract(Duration(days: value)));
      break;
    case 1:
      currentDate = new DateTime(
        date.year,
        date.month - value,
        date.day,
        date.hour,
      );
      return DateFormat('MMMM', 'es').format(currentDate) +
          " del " +
          DateFormat('yyyy').format(currentDate);
      break;
    case 2:
      currentDate = new DateTime(
        date.year - value,
        date.month,
        date.day,
        date.hour,
      );
      return DateFormat('yyyy').format(currentDate);
      break;
    default:
      return '----';
      break;
  }
}

String formatoFecha(DateTime value) {
  if (value == null) return '';
  return DateFormat('dd').format(value) +
      " de " +
      DateFormat('MMMM', 'es').format(value) +
      " del " +
      DateFormat('yyyy').format(value);
}

String formatoFechaExplore(DateTime date, int type, int value) {
  if (date == null) return '';

  DateTime currentDate;
  switch (type) {
    case 0:
      return DateFormat('dd').format(date.subtract(Duration(days: value))) +
          "/" +
          DateFormat('MM').format(date.subtract(Duration(days: value))) +
          "/" +
          DateFormat('yyyy').format(date.subtract(Duration(days: value)));
      break;
    case 1:
      currentDate = new DateTime(
        date.year,
        date.month - value,
        date.day,
        date.hour,
      );
      return DateFormat('MM', 'es').format(currentDate) +
          "/" +
          DateFormat('yyyy').format(currentDate);
      break;
    case 2:
      currentDate = new DateTime(
        date.year - value,
        date.month,
        date.day,
        date.hour,
      );
      return DateFormat('yyyy').format(currentDate);
      break;
    default:
      currentDate = new DateTime(
        date.year - value,
        date.month,
        date.day,
        date.hour,
      );
      return DateFormat('yyyy').format(currentDate);
      break;
  }
}

String formatoFechaHora(DateTime value) {
  if (value == null) return '';
  return DateFormat('dd').format(value) +
      "/" +
      DateFormat('MMMM', 'es').format(value) +
      "/" +
      DateFormat('yyyy').format(value) +
      "  " +
      DateFormat('HH:mm').format(value);
}

String formatoHora(DateTime value, [String key='Hora']) {
  if (value == null) return null;
  return DateFormat('hh:mm a').format(value);
}
