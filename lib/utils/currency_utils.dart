import 'package:intl/intl.dart';

class CurrencyUtils {
  static final _formatter =
  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  static String formatToIdr(int value) {
    return _formatter.format(value);
  }

  static int parseFromIdr(String formatted) {
    final numeric = formatted.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numeric) ?? 0;
  }
}
