import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:taskorganizer/app/date/models/task_notification.dart';

class TaskNotificationCard extends StatelessWidget {
  final TaskNotification taskNotification;

  const TaskNotificationCard({
    super.key,
    required this.taskNotification,
  });

  String _formatDate(DateTime date) {
    String locale = Get.deviceLocale.toString();
    initializeDateFormatting(locale);
    return DateFormat('dd MMMM, HH:mm', locale).format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: taskNotification.isShown ? Theme.of(context).focusColor : Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_formatDate(taskNotification.timeReceipt), style: Theme.of(context).textTheme.bodyLarge,),
            Text(taskNotification.description, style: Theme.of(context).textTheme.bodyMedium,),
          ],
        ),
      ),
    );
  }
}
