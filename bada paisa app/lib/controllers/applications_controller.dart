import 'package:get/get.dart';

import '../app/services/storage_service.dart';
import '../models/loan_application_model.dart';

class ApplicationsController extends GetxController {
  final RxList<LoanApplicationModel> applications =
      <LoanApplicationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() => applications.assignAll(StorageService.to.getApplications());
}
