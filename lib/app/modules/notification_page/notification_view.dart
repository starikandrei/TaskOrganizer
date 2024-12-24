import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskorganizer/app/date/models/task_notification.dart';
import 'package:taskorganizer/app/modules/notification_page/notification_controller.dart';
import 'package:taskorganizer/app/modules/notification_page/widgets/task_notification_card.dart';
import 'package:taskorganizer/app/routes/app_pages.dart';
import 'package:taskorganizer/generated/locales.g.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_sharp),
        ),
        title: Text(LocaleKeys.appName.tr),
      ),
      body: PopScope(
        onPopInvokedWithResult: (didPop, result) =>
            controller.updateNotification(),
        child: Obx(
          () => ListView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            children: [
              const SizedBox(height: 20),
              Text(
                LocaleKeys.notifications.tr,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              FirestorePagination(
                key: UniqueKey(),
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, docs, index) {
                  controller.taskNotifications.value = docs
                      .map(
                        (e) => e.data()! as TaskNotification,
                      )
                      .toList();
                  return controller.taskNotifications.isEmpty
                      ? Center(
                          child: Text(
                            LocaleKeys.notNotification.tr,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        )
                      : TaskNotificationCard(
                          taskNotification:
                              controller.taskNotifications[index]);
                },
                query: controller.taskNotificationQuery.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
