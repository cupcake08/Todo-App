import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/controllers.dart';
import 'package:todo_app/models/models.dart';
import 'package:todo_app/ui/widgets/task_form.dart';
import 'package:todo_app/util/utils.dart';

class ExpandedTaskWidget extends StatelessWidget {
  const ExpandedTaskWidget({
    super.key,
    required this.task,
  });
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            task.description,
            maxLines: null,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const Divider(),
        Row(
          children: [
            Text(
              "Due Time : ",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${task.dueTime.hour}:${task.dueTime.minute}   ${task.dueTime.year}-${task.dueTime.month}-${task.dueTime.day}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.teal.shade200),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              "Creation Time : ",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${task.creationTime.hour}:${task.creationTime.minute}   ${task.creationTime.year}-${task.creationTime.month}-${task.creationTime.day}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.teal.shade200),
            ),
          ],
        ),
        const Divider(),
        // set the reminder
        Row(
          children: [
            task.reminderTime != null && task.reminderTime!.compareTo(DateTime.now()) > 0
                ? Row(
                    children: [
                      Text(
                        "Reminder: ",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        '${task.reminderTime!.hour}:${task.reminderTime!.minute}   ${task.reminderTime!.year}-${task.reminderTime!.month}-${task.reminderTime!.day}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.teal.shade200),
                      ),
                    ],
                  )
                : OutlinedButton(
                    onPressed: () async => Common.setReminder(task),
                    child: const Text("Set Reminder"),
                  ),
            const Spacer(),
            IconButton(
              onPressed: () => _editTask(context),
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            ),
            IconButton(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text("Detete Task"),
                    content: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Are you sure you want to delete ",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextSpan(
                            text: task.title,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.teal),
                          ),
                          TextSpan(
                            text: " ?",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        onPressed: () {
                          Get.find<TaskController>().deleteTask(task);
                          Get.back();
                        },
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<dynamic> _editTask(BuildContext context) {
    return Get.dialog(
      AlertDialog(
        titlePadding: const EdgeInsets.only(top: 0),
        title: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: Text(
            "Edit Task",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ),
        content: TaskForm(task: task),
      ),
      name: "Edit Dialogue",
      barrierColor: Colors.teal.shade100.withOpacity(.3),
    );
  }
}
