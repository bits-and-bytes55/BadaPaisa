import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/loan_application_controller.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/loan_step_scaffold.dart';
import '../widgets/selection_cards.dart';

class PurposeStepView extends GetView<LoanApplicationController> {
  const PurposeStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return LoanStepScaffold(
      step: 3,
      title: 'Purpose of Loan',
      onContinue: controller.continueFromPurpose,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        itemCount: controller.purposes.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (_, i) {
          final p = controller.purposes[i];
          return FadeSlideIn(
            index: i,
            child: Obx(
              () => HorizontalOptionCard(
                option: p,
                height: 84,
                selected: controller.purpose.value == p.id,
                onTap: () => controller.purpose.value = p.id,
              ),
            ),
          );
        },
      ),
    );
  }
}
