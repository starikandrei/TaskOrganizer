import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:taskorganizer/app/date/models/task.dart';
import 'package:taskorganizer/generated/locales.g.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Function(Task task) changeState;
  final Function(Task task) onDelete;
  final Function() onSelect;

  const TaskCard({
    super.key,
    required this.task,
    required this.changeState,
    required this.onDelete,
    required this.onSelect,
  });

  String _formatDate(DateTime date) {
    String locale = Get.deviceLocale.toString();
    initializeDateFormatting(locale);
    return DateFormat('dd MMMM, HH:mm', locale).format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: task.isCompleted ? Get.theme.focusColor : Get.theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => changeState(task),
                  child: Checkbox(value: task.isCompleted, onChanged: null),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: onSelect,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                task.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Text(
                              _formatDate(task.endDate),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          task.creationDate.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => onDelete(task),
                    child: Text(
                      LocaleKeys.delete.tr,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
