import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/loan_application_controller.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/loan_step_scaffold.dart';
import '../widgets/selection_cards.dart';

class CityStepView extends GetView<LoanApplicationController> {
  const CityStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return LoanStepScaffold(
      step: 2,
      title: 'Select City You Live In',
      onContinue: controller.continueFromCity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth - 48 - 24) / 2;
          final circle = itemWidth.clamp(80.0, 116.0);
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Obx(
              () => Wrap(
                alignment: WrapAlignment.center,
                spacing: 24,
                runSpacing: 18,
                children: List.generate(controller.cities.length, (i) {
                  final c = controller.cities[i];
                  return SizedBox(
                    width: itemWidth,
                    child: FadeSlideIn(
                      index: i,
                      child: CircleOptionCard(
                        option: c,
                        size: circle,
                        selected: controller.city.value == c.id,
                        onTap: () => controller.city.value = c.id,
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
