import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/controllers.dart';
import 'package:todo_app/models/models.dart';
import 'package:todo_app/ui/widgets/widget.dart';
import 'package:todo_app/util/utils.dart';

class TaskDetail extends StatelessWidget {
  const TaskDetail({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (controller) {
        final taskM = controller.tasks.firstWhere((element) => element.id == task.id);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  taskM.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.teal),
                ),
                Common.getPriorityWidget(taskM),
              ],
            ),
            ExpandedTaskWidget(task: taskM),
          ],
        );
      },
    );
  }
}
