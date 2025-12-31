import 'dart:math';
import 'package:intl/intl.dart';

class MoneyUtils {
  static String formatCurrency(double value) {
    final nf = NumberFormat("#,##0.00", "de_DE");
    return nf.format(value);
  }

  static double roundDouble(double value, int places) {
    final mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
