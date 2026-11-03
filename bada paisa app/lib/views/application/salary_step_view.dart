import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../app/config/theme/app_theme.dart';
import '../../app/utils/formatters.dart';
import '../../app/utils/validators.dart';
import '../../controllers/loan_application_controller.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loan_step_scaffold.dart';

class SalaryStepView extends GetView<LoanApplicationController> {
  const SalaryStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoanStepScaffold(
        step: 5,
        title: 'Salary Details',
        buttonText: 'Apply Now',
        isLoading: controller.isSubmitting.value,
        onContinue: controller.submit,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SalarySliderCard(),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Monthly Salary',
                  isRequired: true,
                  prefixText: '₹',
                  controller: controller.salaryController,
                  keyboardType: TextInputType.number,
                  inputFormatters: const [
                    IndianNumberInputFormatter(maxDigits: 9),
                  ],
                  onChanged: controller.onSalaryTyped,
                  validator: (v) =>
                      Validators.amount(v, field: 'Monthly salary'),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Loan Required',
                  isRequired: true,
                  prefixText: '₹',
                  controller: controller.loanAmountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: const [IndianNumberInputFormatter()],
                  validator: (v) => Validators.amount(v, field: 'Loan amount'),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Full Name',
                  isRequired: true,
                  icon: Icons.person_outline_rounded,
                  hint: 'Enter your full name',
                  controller: controller.nameController,
                  textCapitalization: TextCapitalization.words,
                  validator: Validators.name,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Email Address',
                  isRequired: true,
                  icon: Icons.mail_outline_rounded,
                  hint: 'name@example.com',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Mobile Number',
                  isRequired: true,
                  prefixText: '+91',
                  hint: '98181 20855',
                  controller: controller.mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: Validators.mobile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SalarySliderCard extends GetView<LoanApplicationController> {
  const _SalarySliderCard();

  @override
  Widget build(BuildContext context) {
    const labels = ['0', '50K', '1L', '1.5L', '2L'];
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.paleBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue),
      ),
      child: Obx(
        () => Column(
          children: [
            Text.rich(
              TextSpan(
                text: 'Monthly Salary: ',
                style: AppTextStyles.bodyDark,
                children: [
                  TextSpan(
                    text:
                        '₹${AppFormatters.number(controller.monthlySalary.value)}',
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Slider(
              value: controller.monthlySalary.value.clamp(
                0,
                LoanApplicationController.maxSalary,
              ),
              max: LoanApplicationController.maxSalary,
              divisions: 40,
              onChanged: controller.onSalarySlider,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: labels
                    .map(
                      (l) => Text(
                        l,
                        style: AppTextStyles.caption.copyWith(fontSize: 11),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
