import 'package:intl/intl.dart';

class Formatters {
  static String money(double amount, String symbol) {
    final format = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return format.format(amount);
  }

  static String date(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  static String monthYear(DateTime date) => DateFormat('MMM yyyy').format(date);

  static String dayShort(DateTime date) =>
      DateFormat('EEE, dd MMM').format(date);
}
