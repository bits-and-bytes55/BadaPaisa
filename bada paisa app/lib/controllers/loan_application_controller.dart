import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/constants/app_data.dart';
import '../app/routes/app_routes.dart';
import '../app/services/notification_service.dart';
import '../app/services/storage_service.dart';
import '../app/utils/app_snackbar.dart';
import '../app/utils/formatters.dart';
import '../models/loan_application_model.dart';
import '../models/loan_product_model.dart';
import '../models/option_model.dart';
import 'applications_controller.dart';
import 'home_controller.dart';
import 'profile_controller.dart';

/// Drives the 5-step loan application flow. Permanent – reset on each start.
class LoanApplicationController extends GetxController {
  static const double maxSalary = 200000;

  final Rx<LoanProductModel> product = AppData.products.first.obs;
  final RxString gender = ''.obs;
  final RxString city = ''.obs;
  final RxString purpose = ''.obs;
  final RxString employment = ''.obs;
  final RxDouble monthlySalary = 100000.0.obs;
  final RxBool isSubmitting = false.obs;
  final Rxn<LoanApplicationModel> lastApplication = Rxn<LoanApplicationModel>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController loanAmountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  List<OptionModel> get genders => AppData.genders;
  List<OptionModel> get cities => AppData.cities;
  List<OptionModel> get purposes => AppData.purposes;
  List<OptionModel> get employmentTypes => AppData.employmentTypes;

  void startApplication(LoanProductModel selected) {
    _reset();
    product.value = selected;
    Get.toNamed(AppRoutes.stepGender);
  }

  void _reset() {
    gender.value = '';
    city.value = '';
    purpose.value = '';
    employment.value = '';
    monthlySalary.value = 100000;
    salaryController.text = AppFormatters.number(100000);
    loanAmountController.text = AppFormatters.number(5000000);
    nameController.text = '';
    emailController.text = '';
    mobileController.text = StorageService.to.phone ?? '';
    isSubmitting.value = false;
    lastApplication.value = null;
  }

  // ---- Step navigation ----
  void _next(RxString value, String message, String route) {
    if (value.value.isEmpty) {
      AppSnackbar.error('Selection required', message);
      return;
    }
    Get.toNamed(route);
  }

  void continueFromGender() =>
      _next(gender, 'Please select your gender', AppRoutes.stepCity);
  void continueFromCity() =>
      _next(city, 'Please select your city', AppRoutes.stepPurpose);
  void continueFromPurpose() =>
      _next(purpose, 'Please select purpose of loan', AppRoutes.stepEmployment);
  void continueFromEmployment() =>
      _next(employment, 'Please select employment type', AppRoutes.stepSalary);

  // ---- Salary ----
  void onSalarySlider(double value) {
    monthlySalary.value = value.roundToDouble();
    salaryController.text = AppFormatters.number(value);
  }

  void onSalaryTyped(String value) {
    monthlySalary.value = AppFormatters.parse(
      value,
    ).clamp(0, maxSalary).toDouble();
  }

  Future<void> submit() async {
    if (isSubmitting.value) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;

    isSubmitting.value = true;
    await Future.delayed(const Duration(milliseconds: 1400)); // simulate API

    final app = LoanApplicationModel(
      id: 'BP${100000000 + Random().nextInt(899999999)}',
      loanType: product.value.title,
      gender: AppData.titleOf(genders, gender.value),
      city: AppData.titleOf(cities, city.value),
      purpose: AppData.titleOf(purposes, purpose.value),
      employmentType: AppData.titleOf(employmentTypes, employment.value),
      monthlySalary: AppFormatters.parse(salaryController.text),
      loanAmount: AppFormatters.parse(loanAmountController.text),
      fullName: nameController.text.trim(),
      email: emailController.text.trim(),
      mobile: mobileController.text.trim(),
      createdAt: DateTime.now(),
    );

    await StorageService.to.addApplication(app);
    if (StorageService.to.userName == null ||
        StorageService.to.userName == 'Anjali') {
      await StorageService.to.saveUserName(app.fullName.split(' ').first);
    }
    lastApplication.value = app;
    isSubmitting.value = false;

    if (Get.isRegistered<ApplicationsController>()) {
      Get.find<ApplicationsController>().load();
    }
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().userName.value =
          StorageService.to.userName ?? 'there';
    }
    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().refreshUser();
    }

    NotificationService.to.show(
      title: 'Application Submitted ✅',
      body:
          'Your ${app.loanType} application (${app.id}) has been submitted. We will contact you soon.',
    );

    Get.offNamedUntil(
      AppRoutes.success,
      (route) => route.settings.name == AppRoutes.main,
    );
  }

  @override
  void onClose() {
    salaryController.dispose();
    loanAmountController.dispose();
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.onClose();
  }
}
