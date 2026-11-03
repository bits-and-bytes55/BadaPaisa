import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/loan_application_model.dart';

/// Wrapper around SharedPreferences. The auth token and all other persisted
/// values are read/written ONLY through this service.
class StorageService extends GetxService {
  static StorageService get to => Get.find<StorageService>();

  late final SharedPreferences _prefs;

  static const _kToken = 'auth_token';
  static const _kOnboardingSeen = 'onboarding_seen';
  static const _kUserName = 'user_name';
  static const _kPhone = 'user_phone';
  static const _kApplications = 'loan_applications';

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // ---- Token ----
  String? get token => _prefs.getString(_kToken);
  bool get isLoggedIn => (token ?? '').isNotEmpty;
  Future<bool> saveToken(String value) => _prefs.setString(_kToken, value);
  Future<bool> clearToken() => _prefs.remove(_kToken);

  // ---- Onboarding ----
  bool get isOnboardingSeen => _prefs.getBool(_kOnboardingSeen) ?? false;
  Future<bool> setOnboardingSeen() => _prefs.setBool(_kOnboardingSeen, true);

  // ---- User ----
  String? get userName => _prefs.getString(_kUserName);
  Future<bool> saveUserName(String value) =>
      _prefs.setString(_kUserName, value);

  String? get phone => _prefs.getString(_kPhone);
  Future<bool> savePhone(String value) => _prefs.setString(_kPhone, value);

  // ---- Applications ----
  List<LoanApplicationModel> getApplications() {
    final raw = _prefs.getStringList(_kApplications) ?? const [];
    final list = <LoanApplicationModel>[];
    for (final item in raw) {
      try {
        list.add(
          LoanApplicationModel.fromJson(
            jsonDecode(item) as Map<String, dynamic>,
          ),
        );
      } catch (_) {
        // skip corrupted entries
      }
    }
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<bool> addApplication(LoanApplicationModel app) {
    final raw = _prefs.getStringList(_kApplications) ?? <String>[];
    return _prefs.setStringList(_kApplications, [
      ...raw,
      jsonEncode(app.toJson()),
    ]);
  }

  Future<void> logout() async {
    await _prefs.remove(_kToken);
  }
}
