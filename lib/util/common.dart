import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/controllers.dart';
import 'package:todo_app/models/models.dart';
import 'package:todo_app/util/utils.dart';

class Common {
  Common._();

  static Future<void> setReminder(Task task) async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: task.reminderTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );

    TimeOfDay? time;
    if (picked != null) {
      time = await showTimePicker(
        context: Get.context!,
        cancelText: null,
        initialTime: task.reminderTime != null ? TimeOfDay.fromDateTime(task.reminderTime!) : TimeOfDay.now(),
      );
    }
    if (picked != null && time != null) {
      final date = DateTime(
        picked.year,
        picked.month,
        picked.day,
        time.hour,
        time.minute,
      );
      Get.find<TaskController>().setReminder(date, task);
    }
  }

  static Widget getPriorityWidget(Task task) {
    late final IconData iconData;
    late final Color color;
    switch (task.priority) {
      case TaskPriority.high:
        iconData = Icons.keyboard_double_arrow_up_rounded;
        color = Colors.red;
        break;
      case TaskPriority.medium:
        iconData = Icons.keyboard_arrow_up_rounded;
        color = Colors.yellow;
        break;
      case TaskPriority.low:
        color = Colors.green;
        iconData = Icons.keyboard_arrow_down_rounded;
        break;
    }
    // return Container(
    //   decoration: BoxDecoration(
    //     shape: BoxShape.circle,
    //     color: color,
    //   ),
    //   height: 25,
    //   width: 25,
    // );
    return Icon(iconData, color: color, size: 40);
  }
}
