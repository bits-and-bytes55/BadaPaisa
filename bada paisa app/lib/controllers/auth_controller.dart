import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../app/services/notification_service.dart';
import '../app/services/storage_service.dart';
import '../app/utils/app_snackbar.dart';
import '../app/utils/validators.dart';

/// Handles Login (mobile number) + OTP verification.
/// Registered as a permanent controller so its text controllers outlive
/// route transitions.
class AuthController extends GetxController {
  final StorageService _storage = StorageService.to;
  final NotificationService _notifications = NotificationService.to;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;
  final RxBool isPhoneValid = false.obs;
  final RxString otp = ''.obs;
  final RxInt secondsLeft = 30.obs;

  Timer? _timer;
  String _generatedOtp = '';

  String get phone => phoneController.text.trim();

  String get formattedPhone => phone.length == 10
      ? '+91 ${phone.substring(0, 5)} ${phone.substring(5)}'
      : '+91 $phone';

  String get timerText => '00:${secondsLeft.value.toString().padLeft(2, '0')}';

  @override
  void onInit() {
    super.onInit();
    final saved = _storage.phone;
    if (saved != null) phoneController.text = saved;
    isPhoneValid.value = Validators.isMobile(phone);
    phoneController.addListener(
      () => isPhoneValid.value = Validators.isMobile(phone),
    );
  }

  Future<void> sendOtp() async {
    if (!isPhoneValid.value) {
      AppSnackbar.error(
        'Invalid number',
        'Please enter a valid 10-digit mobile number',
      );
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;
    await _notifications.requestPermission();
    await Future.delayed(
      const Duration(milliseconds: 1100),
    ); // simulate API call
    isLoading.value = false;
    _generateOtp();
    Get.toNamed(AppRoutes.otp);
  }

  void _generateOtp() {
    _generatedOtp = (100000 + Random().nextInt(900000)).toString();
    otpController.clear();
    otp.value = '';
    _startTimer();
    _notifications.show(
      title: 'BadaPaisa Verification Code',
      body:
          '$_generatedOtp is your BadaPaisa OTP. Do not share it with anyone.',
    );
    AppSnackbar.info(
      'OTP Sent',
      'OTP sent to $formattedPhone (Demo OTP: $_generatedOtp)',
    );
  }

  void resendOtp() {
    if (secondsLeft.value > 0) return;
    _generateOtp();
  }

  void _startTimer() {
    _timer?.cancel();
    secondsLeft.value = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value <= 1) {
        secondsLeft.value = 0;
        t.cancel();
      } else {
        secondsLeft.value--;
      }
    });
  }

  void onOtpChanged(String value) {
    otp.value = value;
    if (value.length == 6) FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> verifyOtp() async {
    if (otp.value.length < 6) {
      AppSnackbar.error('Incomplete OTP', 'Please enter the 6-digit code');
      return;
    }
    if (otp.value != _generatedOtp) {
      AppSnackbar.error('Incorrect OTP', 'The code you entered is incorrect');
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    await _completeLogin(phone);
    isLoading.value = false;
  }

  Future<void> continueWithGoogle() async {
    isGoogleLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1200));
    await _notifications.requestPermission();
    await _completeLogin(phone);
    isGoogleLoading.value = false;
  }

  Future<void> _completeLogin(String mobile) async {
    final token =
        'bp_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(99999)}';
    await _storage.saveToken(token);
    if (mobile.isNotEmpty) await _storage.savePhone(mobile);
    if (_storage.userName == null) await _storage.saveUserName('Anjali');
    _timer?.cancel();
    _notifications.show(
      title: 'Welcome to BadaPaisa 🎉',
      body:
          'You have logged in successfully. Find the right loan for your needs.',
    );
    Get.offAllNamed(AppRoutes.main);
  }

  @override
  void onClose() {
    _timer?.cancel();
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
