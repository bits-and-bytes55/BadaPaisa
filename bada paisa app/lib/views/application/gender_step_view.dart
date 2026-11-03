import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/loan_application_controller.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/loan_step_scaffold.dart';
import '../widgets/selection_cards.dart';

class GenderStepView extends GetView<LoanApplicationController> {
  const GenderStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return LoanStepScaffold(
      step: 1,
      title: 'Select Gender',
      onContinue: controller.continueFromGender,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SizedBox(
            height: 230,
            child: Obx(
              () => Row(
                children: List.generate(controller.genders.length, (i) {
                  final g = controller.genders[i];
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: FadeSlideIn(
                        index: i,
                        child: VerticalOptionCard(
                          option: g,
                          selected: controller.gender.value == g.id,
                          onTap: () => controller.gender.value = g.id,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
