import 'package:get/get.dart';

import '../../views/application/city_step_view.dart';
import '../../views/application/employment_step_view.dart';
import '../../views/application/gender_step_view.dart';
import '../../views/application/purpose_step_view.dart';
import '../../views/application/salary_step_view.dart';
import '../../views/application/success_view.dart';
import '../../views/auth/login_view.dart';
import '../../views/auth/otp_view.dart';
import '../../views/emi/emi_calculator_view.dart';
import '../../views/loans/apply_loan_view.dart';
import '../../views/loans/loan_products_view.dart';
import '../../views/main/main_view.dart';
import '../../views/notifications/notifications_view.dart';
import '../../views/onboarding/onboarding_view.dart';
import '../../views/splash/splash_view.dart';
import '../bindings/app_bindings.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      transition: Transition.fadeIn,
    ),
    GetPage(name: AppRoutes.otp, page: () => const OtpView()),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainView(),
      binding: MainBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(name: AppRoutes.loanProducts, page: () => const LoanProductsView()),
    GetPage(name: AppRoutes.applyLoan, page: () => const ApplyLoanView()),
    GetPage(name: AppRoutes.stepGender, page: () => const GenderStepView()),
    GetPage(name: AppRoutes.stepCity, page: () => const CityStepView()),
    GetPage(name: AppRoutes.stepPurpose, page: () => const PurposeStepView()),
    GetPage(
      name: AppRoutes.stepEmployment,
      page: () => const EmploymentStepView(),
    ),
    GetPage(name: AppRoutes.stepSalary, page: () => const SalaryStepView()),
    GetPage(
      name: AppRoutes.success,
      page: () => const SuccessView(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: AppRoutes.emiCalculator,
      page: () => const EmiCalculatorView(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
    ),
  ];
}
