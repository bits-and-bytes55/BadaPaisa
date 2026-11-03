import 'package:bada_paisa/app/utils/formatters.dart';
import 'package:bada_paisa/controllers/emi_calculator_controller.dart';
import 'package:bada_paisa/controllers/loan_application_controller.dart';
import 'package:bada_paisa/views/application/employment_step_view.dart';
import 'package:bada_paisa/views/application/purpose_step_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  test('Indian number formatting', () {
    expect(AppFormatters.number(100000), '1,00,000');
    expect(AppFormatters.parse('50,00,000'), 5000000);
  });

  test('EMI calculation', () {
    final emi = EmiCalculatorController.calculateEmi(5000000, 6.9, 20);
    expect(emi.round(), inInclusiveRange(38400, 38500));
  });

  testWidgets('purpose and employment steps build without GetX scope errors', (
    tester,
  ) async {
    Get.testMode = true;
    Get.put(LoanApplicationController());

    await tester.pumpWidget(
      const GetMaterialApp(home: PurposeStepView()),
    );
    await tester.pump();
    expect(find.text('Purpose of Loan'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      const GetMaterialApp(home: EmploymentStepView()),
    );
    await tester.pump();
    expect(find.text('Employment Type'), findsOneWidget);
    expect(tester.takeException(), isNull);

    Get.reset();
  });
}
