import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taskorganizer/app/date/models/task.dart';
import 'package:taskorganizer/app/date/models/task_notification.dart';
import 'package:taskorganizer/app/theme/app_colors.dart';
import 'package:taskorganizer/generated/locales.g.dart';

class CreateTaskBottomSheet extends StatelessWidget {
  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final Rx<DateTime> endDate = DateTime.now().obs;
  final Rx<DateTime> warningDate = DateTime.now().obs;

  final Function(Task task, TaskNotification taskNotification)
      createTaskAndNotification;

  CreateTaskBottomSheet({super.key, required this.createTaskAndNotification});

  void _submitForm(var formKey) {
    if (formKey.currentState!.validate()) {
      Task task = Task(
        userId: "",
        name: name.text,
        description: description.text,
        isCompleted: false,
        endDate: endDate.value,
        creationDate: DateTime.now(),
      );
      TaskNotification taskNotification = TaskNotification(
        userId: "",
        taskId: "",
        description: TaskNotification.setNotificationDescription(
            name.text, endDate.value),
        isShown: false,
        timeReceipt: warningDate.value,
      );
      createTaskAndNotification(task, taskNotification);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 25),
          Text(
            LocaleKeys.creatingAnTask.tr,
            style: Get.theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Form(
              key: formKey,
              child: Obx(
                () => ListView(
                  children: [
                    TextFormField(
                      controller: name,
                      decoration:
                          InputDecoration(labelText: LocaleKeys.taskName.tr),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.incorrectTaskName.tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: description,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.taskDescription.tr,
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.incorrectTaskDescription.tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: LocaleKeys.endDate.tr),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: endDate.value,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(endDate.value),
                          );
                          if (pickedTime != null) {
                            endDate.value = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          }
                        }
                      },
                      validator: (value) {
                        if (endDate.value.isBefore(DateTime.now())) {
                          return LocaleKeys.incorrectEndDate1.tr;
                        }
                        if (endDate.value.isAfter(DateTime(2101))) {
                          return LocaleKeys.incorrectEndDate1.tr;
                        }
                        return null;
                      },
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy HH:mm')
                            .format(endDate.value),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: LocaleKeys.warningDate.tr,
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: warningDate.value,
                          firstDate: DateTime.now(),
                          lastDate: endDate.value,
                        );
                        if (pickedDate != null) {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay.fromDateTime(warningDate.value),
                          );
                          if (pickedTime != null) {
                            warningDate.value = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          }
                        }
                      },
                      validator: (value) {
                        if (warningDate.value.isBefore(DateTime.now())) {
                          return LocaleKeys.incorrectWarningDate1.tr;
                        }
                        if (warningDate.value.isAfter(endDate.value)) {
                          return LocaleKeys.incorrectEndDate2.tr;
                        }
                        return null;
                      },
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy HH:mm')
                            .format(warningDate.value),
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () => _submitForm(formKey),
                      child: Text(
                        LocaleKeys.apply.tr,
                        style: TextStyle(color: AppColors.iconDark),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
