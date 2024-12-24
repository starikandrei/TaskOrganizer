import 'package:get/get.dart';
import 'package:taskorganizer/app/modules/home_page/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        Get.find(),
        Get.find(),
        Get.find(),
      ),
    );
  }
}
