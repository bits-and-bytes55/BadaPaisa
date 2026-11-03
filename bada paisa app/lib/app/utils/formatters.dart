import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: 0,
  );
  static final NumberFormat _number = NumberFormat.decimalPattern('en_IN');

  /// 3862.4 -> "₹ 3,862"
  static String currency(num value) => _currency.format(value.round());

  /// 100000 -> "1,00,000"
  static String number(num value) => _number.format(value.round());

  /// "1,00,000" -> 100000
  static double parse(String value) =>
      double.tryParse(value.replaceAll(',', '').replaceAll('₹', '').trim()) ??
      0;

  static String date(DateTime d) => DateFormat('dd MMM yyyy').format(d);
}

/// Formats digits with Indian grouping while typing (1,00,000).
class IndianNumberInputFormatter extends TextInputFormatter {
  const IndianNumberInputFormatter({this.maxDigits = 11});
  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return const TextEditingValue();
    if (digits.length > maxDigits) digits = digits.substring(0, maxDigits);
    final formatted = AppFormatters.number(int.parse(digits));
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
