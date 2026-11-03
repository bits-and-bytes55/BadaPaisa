import 'package:get/get.dart';

/// Bottom navigation state.
class MainController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTab(int index) => currentIndex.value = index;
}
