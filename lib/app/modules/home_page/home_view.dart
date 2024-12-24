import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskorganizer/app/date/models/task.dart';
import 'package:taskorganizer/app/modules/home_page/widgets/change_task_bottom_sheet.dart';
import 'package:taskorganizer/app/modules/home_page/widgets/create_task_bottom_sheet.dart';
import 'package:taskorganizer/app/modules/home_page/widgets/task_card.dart';
import 'package:taskorganizer/app/routes/app_pages.dart';
import 'package:taskorganizer/app/theme/app_colors.dart';
import 'package:taskorganizer/generated/locales.g.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  static final sortingOptions = [
    LocaleKeys.byCreationDate,
    LocaleKeys.byCompletionDate,
  ];

  const HomeView({super.key});

  void _showCreateTaskBottomSheet(BuildContext context) {
    Get.bottomSheet(
      backgroundColor: Get.theme.bottomSheetTheme.backgroundColor,
      CreateTaskBottomSheet(
        createTaskAndNotification: controller.addTaskAndNotification,
      ),
    );
  }

  void _showChangeTaskBottomSheet(BuildContext context, Task task) async {
    var taskNotification = await controller.taskNotificationService
        .getNotificationByTaskId(task.id!);
    Get.bottomSheet(
      backgroundColor: Get.theme.bottomSheetTheme.backgroundColor,
      ChangeTaskBottomSheet(
        task: task,
        taskNotification: taskNotification!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.tasks.tr),
        actions: [
          IconButton(
            onPressed: () =>  Get.toNamed(Routes.NOTIFICATION),
            icon: Obx(
              () => Stack(
                children: [
                  Icon(Icons.notifications_none),
                  if (controller.unreadCount.value > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => Get.offAndToNamed(Routes.SETTINGS),
            icon: Icon(Icons.settings),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  "${LocaleKeys.filters.tr} | ${LocaleKeys.sorting.tr}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: AppColors.iconDark,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "|",
                        style: TextStyle(
                          color: AppColors.iconDark,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Icon(
                        Icons.sort,
                        color: AppColors.iconDark,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Obx(
            () => FirestorePagination(
              key: UniqueKey(),
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, docs, index) {
                controller.filteredTasks.value = docs
                    .map(
                      (e) => e.data()! as Task,
                    )
                    .toList();
                return controller.filteredTasks.isEmpty
                    ? Center(
                        child: Text(
                          LocaleKeys.noTasksCreated.tr,
                          style: Get.theme.textTheme.titleLarge,
                        ),
                      )
                    : TaskCard(
                        task: controller.filteredTasks[index],
                        changeState: controller.changeStateTask,
                        onDelete: controller.deleteTask,
                        onSelect: () => _showChangeTaskBottomSheet(
                            context, controller.filteredTasks[index]),
                      );
              },
              query: controller.tasksQuery.value,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Obx(
          () => ListView(
            padding: EdgeInsets.all(15),
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      LocaleKeys.filters.tr,
                      style: Get.theme.textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: Get.theme.iconTheme.color,
                      ))
                ],
              ),
              const SizedBox(height: 10),
              Text(
                LocaleKeys.byTaskStatus.tr,
                style: Get.theme.textTheme.bodyLarge,
              ),
              Row(
                children: [
                  Radio<bool?>(
                    value: null,
                    groupValue: controller.filterTaskWithStatusTag.value,
                    onChanged: (value) {
                      controller.filterTaskWithStatusTag.value = value;
                    },
                  ),
                  Expanded(
                    child: Text(
                      LocaleKeys.without.tr,
                      style: Get.theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio<bool?>(
                    value: false,
                    groupValue: controller.filterTaskWithStatusTag.value,
                    onChanged: (value) {
                      controller.filterTaskWithStatusTag.value = value;
                    },
                  ),
                  Expanded(
                    child: Text(
                      LocaleKeys.notCompleted.tr,
                      style: Get.theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio<bool?>(
                    value: true,
                    groupValue: controller.filterTaskWithStatusTag.value,
                    onChanged: (value) {
                      controller.filterTaskWithStatusTag.value = value;
                    },
                  ),
                  Expanded(
                    child: Text(
                      LocaleKeys.completed.tr,
                      style: Get.theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                LocaleKeys.sorting.tr,
                style: Get.theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Column(
                children: List.generate(
                  sortingOptions.length,
                  (index) => Row(
                    children: [
                      Radio<String>(
                        value: sortingOptions[index],
                        groupValue: controller.sortingTaskTag.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.sortingTaskTag.value = value;
                          }
                        },
                      ),
                      Expanded(
                        child: Text(
                          sortingOptions[index].tr,
                          style: Get.theme.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () => controller.updateTasks(),
                  child: Text(
                    LocaleKeys.apply.tr,
                    style: TextStyle(
                      color: AppColors.iconDark,
                    ),
                  ))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTaskBottomSheet(context),
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.add,
          color: AppColors.backgroundLight,
        ),
      ),
    );
  }
}
