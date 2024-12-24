import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taskorganizer/app/date/models/task.dart';
import 'package:taskorganizer/app/date/models/task_notification.dart';
import 'package:taskorganizer/app/date/services/task_notification_service.dart';
import 'package:taskorganizer/app/date/services/tasks_service.dart';
import 'package:taskorganizer/app/theme/app_colors.dart';
import 'package:taskorganizer/generated/locales.g.dart';

class ChangeTaskBottomSheet extends StatelessWidget {
  final Task task;
  final TaskNotification taskNotification;
  final TaskService _taskService = Get.find();
  final TaskNotificationService _taskNotificationService = Get.find();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final RxBool _isCompleted = false.obs;
  final Rx<DateTime> _endDate = DateTime.now().obs;
  final Rx<DateTime> _warningDate = DateTime.now().obs;

  ChangeTaskBottomSheet({
    super.key,
    required this.task,
    required this.taskNotification,
  }) {
    _name.text = task.name;
    _description.text = task.description;
    _isCompleted.value = task.isCompleted;
    _endDate.value = task.endDate;
    _warningDate.value = taskNotification.timeReceipt;
  }

  void _submitForm(var formKey) {
    if (formKey.currentState!.validate()) {
      task.name = _name.text;
      task.description = _description.text;
      task.isCompleted = _isCompleted.value;
      task.endDate = _endDate.value;
      taskNotification.timeReceipt = _warningDate.value;
      taskNotification.description =
          TaskNotification.setNotificationDescription(
        task.name,
        task.endDate,
      );

      _taskService.updateTask(task);
      _taskNotificationService.updateNotification(taskNotification);
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
            LocaleKeys.changeTask.tr,
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
                      controller: _name,
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
                      controller: _description,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            LocaleKeys.completed.tr,
                            style: Get.textTheme.bodyMedium,
                          ),
                        ),
                        Switch(
                          value: _isCompleted.value,
                          onChanged: (value) {
                            _isCompleted.value = value;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: LocaleKeys.endDate.tr),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _endDate.value,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_endDate.value),
                          );
                          if (pickedTime != null) {
                            _endDate.value = DateTime(
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
                        if (_endDate.value.isBefore(DateTime.now())) {
                          return LocaleKeys.incorrectEndDate1.tr;
                        }
                        if (_endDate.value.isAfter(DateTime(2101))) {
                          return LocaleKeys.incorrectEndDate2.tr;
                        }
                        return null;
                      },
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy HH:mm')
                            .format(_endDate.value),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: LocaleKeys.warningDate.tr,
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _warningDate.value,
                          firstDate: DateTime.now(),
                          lastDate: _endDate.value,
                        );
                        if (pickedDate != null) {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay.fromDateTime(_warningDate.value),
                          );
                          if (pickedTime != null) {
                            _warningDate.value = DateTime(
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
                        if (_warningDate.value.isBefore(DateTime.now())) {
                          return LocaleKeys.incorrectWarningDate1;
                        }
                        if (_warningDate.value.isAfter(_endDate.value)) {
                          return LocaleKeys.incorrectWarningDate2;
                        }
                        return null;
                      },
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy HH:mm')
                            .format(_warningDate.value),
                      ),
                    ),
                    SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () => _submitForm(formKey),
                      child: Text(
                        LocaleKeys.save.tr,
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
