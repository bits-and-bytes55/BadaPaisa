import 'package:get/get.dart';

import 'formatters.dart';

class Validators {
  Validators._();

  static final RegExp _mobile = RegExp(r'^[6-9]\d{9}$');

  static bool isMobile(String v) => _mobile.hasMatch(v.trim());

  static String? mobile(String? v) =>
      isMobile(v ?? '') ? null : 'Enter a valid 10-digit mobile number';

  static String? name(String? v) =>
      (v ?? '').trim().length >= 3 ? null : 'Enter your full name';

  static String? email(String? v) =>
      GetUtils.isEmail((v ?? '').trim()) ? null : 'Enter a valid email address';

  static String? amount(String? v, {String field = 'Amount'}) =>
      AppFormatters.parse(v ?? '') > 0 ? null : '$field is required';
}
