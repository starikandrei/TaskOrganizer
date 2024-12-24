import 'package:get/get.dart';
import 'package:taskorganizer/app/modules/notification_page/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(
      () => NotificationController(
        Get.find(),
        Get.find(),
      ),
    );
  }
}
