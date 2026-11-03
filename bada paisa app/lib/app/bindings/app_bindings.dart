import 'package:get/get.dart';

import '../../controllers/applications_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/emi_calculator_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/loan_application_controller.dart';
import '../../controllers/main_controller.dart';
import '../../controllers/notifications_controller.dart';
import '../../controllers/onboarding_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/splash_controller.dart';

/// App-wide controllers that own TextEditingControllers are kept permanent
/// so they are never disposed while a route is still animating out.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(LoanApplicationController(), permanent: true);
    Get.put(EmiCalculatorController(), permanent: true);
    Get.put(NotificationsController(), permanent: true);
  }
}

class SplashBinding extends Bindings {
  @override
  // Eager: the splash view never reads the controller, so lazyPut would
  // never create it and onReady (navigation) would never fire.
  void dependencies() {
    Get.put(SplashController());
  }
}

class OnboardingBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => OnboardingController());
}

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => ApplicationsController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
  }
}
