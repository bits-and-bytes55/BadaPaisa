import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../app/services/storage_service.dart';

class SplashController extends GetxController {
  final StorageService _storage = StorageService.to;

  @override
  void onReady() {
    super.onReady();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2600));
    if (_storage.isLoggedIn) {
      Get.offAllNamed(AppRoutes.main);
    } else if (_storage.isOnboardingSeen) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }
}
