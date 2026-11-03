import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/loan_application_controller.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/loan_step_scaffold.dart';
import '../widgets/selection_cards.dart';

class EmploymentStepView extends GetView<LoanApplicationController> {
  const EmploymentStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return LoanStepScaffold(
      step: 4,
      title: 'Employment Type',
      onContinue: controller.continueFromEmployment,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        itemCount: controller.employmentTypes.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (_, i) {
          final e = controller.employmentTypes[i];
          return FadeSlideIn(
            index: i,
            child: Obx(
              () => HorizontalOptionCard(
                option: e,
                height: 92,
                selected: controller.employment.value == e.id,
                onTap: () => controller.employment.value = e.id,
              ),
            ),
          );
        },
      ),
    );
  }
}
