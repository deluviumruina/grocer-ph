import 'package:intl/intl.dart';

class GFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  static String formatShortDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MM-yy').format(date);
  }

  static String formatPrice(double price) {
    return NumberFormat('#,##0.00').format(price);
  }
}